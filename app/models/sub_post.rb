class SubPost < ApplicationRecord
  validates :title, length: { minimum: 1, maximum: 80 }, presence: true
  validates :content, length: { minimum: 1, maximum: 30000 }, presence: true
  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :main_post
end
