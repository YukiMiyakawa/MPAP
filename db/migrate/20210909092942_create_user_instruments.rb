class CreateUserInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_instruments do |t|
      t.integer :user_id, :null =>false
      t.integer :instrument_id, :null =>false

      t.timestamps
    end
  end
end
