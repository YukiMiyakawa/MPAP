class MusicGenre < ApplicationRecord
  has_many :user_music_genres, dependent: :destroy
end
