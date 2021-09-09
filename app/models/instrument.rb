class Instrument < ApplicationRecord
  has_many :user_instruments, dependent: :destroy
end
