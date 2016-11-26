class User < ActiveRecord::Base
  has_many :user_files

  has_secure_password

  validates :name,
            presence: true,
            uniqueness: true

  def self.digest(str)
    # need to figure out the cost because while in dev/testing, activemodel
    # switches to a minimal cost, as bcrypt is designed to be computationally
    # expensive (for security purposes). don't need great security during dev.
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end

    BCrypt::Password.create(str, cost: cost)
  end
end
