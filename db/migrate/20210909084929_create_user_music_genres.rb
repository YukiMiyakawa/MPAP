class CreateUserMusicGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :user_music_genres do |t|
      t.integer :user_id, :null =>false
      t.integer :music_genre_id, :null =>false

      t.timestamps
    end
  end
end
