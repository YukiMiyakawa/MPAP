class CreatePostTags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_tags do |t|
      t.integer :main_post_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end
  end
end
