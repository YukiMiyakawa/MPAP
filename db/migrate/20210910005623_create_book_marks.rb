class CreateBookMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :book_marks do |t|
      t.integer :user_id, :null =>false
      t.integer :main_post_id, :null =>false

      t.timestamps
    end
  end
end
