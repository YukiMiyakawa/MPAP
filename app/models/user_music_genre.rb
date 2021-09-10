class UserMusicGenre < ApplicationRecord
  belongs_to :user
  belongs_to :music_genre
end
