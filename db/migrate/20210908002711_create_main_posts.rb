class CreateMainPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :main_posts do |t|
      t.integer :user_id, :null =>false
      t.string :title, :null =>false
      t.text :content, :null =>false
      t.string :image_id
      t.boolean :practice_status, :null =>false, default: false
      t.boolean :public_status, :null =>false, default: false

      t.timestamps
    end
  end
end
