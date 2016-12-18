class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :plan
  
  attr_accessor :stripe_card_token
  # If Pro user passes validations(email, password, etc.), then call Stripe,
  # and tell Stripe to set up a subscription upon charging the customers,
  # card (card token).
  # Stripe responds back with customer data and we store customer.id as,
  # the customer token and save the user.
  
  # from registrations_controller, our defined exention of Devise registration.
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
