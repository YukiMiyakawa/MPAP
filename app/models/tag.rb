class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :main_posts, through: :post_tags
  validates :name, uniqueness: true
end
