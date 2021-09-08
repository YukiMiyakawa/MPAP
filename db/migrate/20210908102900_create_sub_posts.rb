class CreateSubPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_posts do |t|
      t.integer :main_post_id, :null =>false
      t.string :title, :null =>false
      t.text :content, :null =>false
      t.string :image_id

      t.timestamps
    end
  end
end
