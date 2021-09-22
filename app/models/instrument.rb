class Instrument < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :user_instruments, dependent: :destroy
end
