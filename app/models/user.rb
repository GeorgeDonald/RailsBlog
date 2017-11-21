class User < ApplicationRecord
  has_secure_password
  validates :loginname, :password, presence: true
  validates :loginname, uniqueness: true
  validates :password, length: {in: 6..20}
  validates :loginname, length: {in: 6..20}
  has_many :blogs, dependent: :destroy
end
