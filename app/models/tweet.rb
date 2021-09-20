class Tweet < ApplicationRecord
  validates :comment, length: { minimum: 1, maximum: 100 }, presence: true
  validates :practice_time, presence: true, numericality: { only_integer: true }
  belongs_to :user
end
