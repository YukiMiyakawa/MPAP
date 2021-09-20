class Task < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 26 }, presence: true
  belongs_to :user
end
