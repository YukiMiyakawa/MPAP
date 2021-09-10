class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.integer :user_id, :null =>false
      t.string :comment, :null =>false
      t.integer :practice_time, :null =>false
      
      t.timestamps
    end
  end
end
