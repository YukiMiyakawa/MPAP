class MusicGenre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :user_music_genres, dependent: :destroy
end
