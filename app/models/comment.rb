class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  validates :blog_id, :contents, :user_id, presence: true
end
