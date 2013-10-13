require 'valid_email'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Validations
  validates :first_name, presence: false
  validates :last_name, presence: false
  #include ActiveModel::Validations
  validates :email, presence: true, :email => true
  validates :phone_number, presence: false
  validates :zipcode, presence: false

  # Plugins/Gems
  acts_as_voter

  # Constants
  ROLES = %w[admin coordinator member]

  # Associations
  has_many :events, through: :event_users
  has_many :event_users

  # Attributes
  #attr_accessible :credit_card
  #
  #attr_accessor :credit_card

  validate do
    if need_credit_card? and credit_card.invalid?
      errors.add :credit_card_id, "Validation error"
    end
  end

  before_save :create_credit_card, :if => :need_credit_card?

  def need_credit_card?
    # credit_card_id.nil? or credit_card.present?
    credit_card.present?
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

  def fetch_credit_card
    @fetch_credit_card ||= credit_card_id && CreditCard.find(credit_card_id)
  end

  def credit_card
    @credit_card ||= CreditCard.new
  end

  def credit_card=(hash)
    @credit_card = CreditCard.new(hash)
  end
end
