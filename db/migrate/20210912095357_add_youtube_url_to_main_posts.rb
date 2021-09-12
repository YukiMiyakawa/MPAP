class AddYoutubeUrlToMainPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :main_posts, :youtube_url, :string
  end
end
