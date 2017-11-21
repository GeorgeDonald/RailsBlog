class Comment < ApplicationRecord
  belongs_to :blog
  validates :blog_id, :contents, presence: true
end
