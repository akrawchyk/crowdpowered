class Order < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event

  # Validations
  validates_presence_of :amount, :user_id, :event_id

  validate do
    if payment_method == "credit_card" and @credit_card.present? and !@credit_card.valid?
      errors.add :create_card, "Validation error"
    end
  end

  # Filters
  after_create :create_payment
  before_save :create_credit_card, :if => :need_credit_card?

  # Attributes
  attr_accessor :return_url, :cancel_url, :payment_method, :credit_card

  def approve_url
    payment.links.find{|link| link.method == "REDIRECT" }.try(:href)
  end

  def create_credit_card
    credit_card.payer_id = self.email
    if credit_card.create
      self.credit_card_id = credit_card.id
      self.credit_card_description = credit_card.description
      true
    else
      errors.add :credit_card_id, "Validation error"
      false
    end
  end

  def create_payment
    if payment_method == "credit_card" and !user.save
      raise ActiveRecord::Rollback, "Can't place the order"
    end

    @payment = Payment.new( :order => self )

    if @payment.create
      self.payment_id = @payment.id
      self.state      = @payment.state
      save
    else
      errors.add :payment_method, @payment.error["message"] if @payment.error
      raise ActiveRecord::Rollback, "Can't place the order"
    end
  end

  def credit_card
    @credit_card ||= CreditCard.new
  end

  def credit_card=(hash)
    @credit_card = CreditCard.new(hash)
  end

  def execute(payer_id)
    if payment.present? and payment.execute(:payer_id => payer_id)
      self.state = payment.state
      save
    else
      errors.add :description, payment.error.inspect
      false
    end
  end

  def fetch_credit_card
    @fetch_credit_card ||= credit_card_id && CreditCard.find(credit_card_id)
  end

  def need_credit_card?
    # credit_card_id.nil? or credit_card.present?
    credit_card.present?
  end


  def payment
    @payment ||= payment_id && Payment.find(payment_id)
  end
end