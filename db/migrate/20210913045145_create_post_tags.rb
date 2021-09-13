class CreatePostTags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_tags do |t|
      t.references :main_post, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    
    add_index :post_tags, [:main_post_id, :tag_id], unique: true
  end
end