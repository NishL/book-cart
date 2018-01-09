class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true # Check the name is present and unique (no two users with same name in the DB)
  has_secure_password
end
