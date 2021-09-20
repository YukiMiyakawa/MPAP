class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy#, foreign_key: 'tag_id'
  has_many :main_posts, through: :post_tags
  validates :name, uniqueness: true, length: { minimum: 1, maximum: 10 }, presence: true

end
