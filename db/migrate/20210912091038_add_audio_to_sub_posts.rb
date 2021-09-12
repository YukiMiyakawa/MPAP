class AddAudioToSubPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :sub_posts, :audio, :string
  end
end
