class MainPost < ApplicationRecord
  attachment :image
  belongs_to :user
  has_many :comments, dependent: :destroy
end
