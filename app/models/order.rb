class Order < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event

  # Validations
  validates_presence_of :amount, :user_id, :event_id

  # Filters
  after_create :create_payment

  # Attributes
  attr_accessor :return_url, :cancel_url, :payment_method, :credit_card

  validate do
    if payment_method == "credit_card" and ( user.credit_card_id.nil? || @credit_card.present? ) and @credit_card.invalid?
      errors.add :create_card, "Validation error"
    end
  end

  def payment
    @payment ||= payment_id && Payment.find(payment_id)
  end

  def credit_card
    user.credit_card
  end

  def credit_card=(hash)
    user.credit_card = hash
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

  def execute(payer_id)
    if payment.present? and payment.execute(:payer_id => payer_id)
      self.state = payment.state
      save
    else
      errors.add :description, payment.error.inspect
      false
    end
  end

  def approve_url
    payment.links.find{|link| link.method == "REDIRECT" }.try(:href)
  end

  def credit_card
    @credit_card ||= CreditCard.new
  end
end