class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true # Check the name is present and unique (no two users with same name in the DB)
  has_secure_password

  after_destroy :ensure_an_admin_remains # Use an ActiveRecord hook method to roll back a transaction

  # This error will get rescued in the users controller
  class Error < StandardError
  end

  private

  # Raise an error when the admin count is zero. In combination with the after_destroy() ActiveRecord hook
  # the transaction will get rolled back.
  def ensure_an_admin_remains
    if User.count.zero?
      raise Error, "Can't delete the last user!"
    end
  end
end
