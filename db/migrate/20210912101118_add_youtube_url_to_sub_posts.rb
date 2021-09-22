class AddYoutubeUrlToSubPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :sub_posts, :youtube_url, :string
  end
end
