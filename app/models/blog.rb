class Blog < ApplicationRecord
  belongs_to :user
  has_many :comments
  validates :user_id, :contents, presence: true
end
