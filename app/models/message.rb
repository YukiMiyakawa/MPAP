class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :body, length: { minimum: 1, maximum: 200 }, presence: true
end
