class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id, :null =>false
      t.string :name, :null =>false
      t.boolean :status, :null =>false, default: true
      t.timestamps
    end
  end
end
