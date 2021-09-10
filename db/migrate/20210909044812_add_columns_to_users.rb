class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_status, :boolean, default: true, null: false
    add_column :users, :introduction, :text
    add_column :users, :target_time, :integer
    add_column :users, :image_id, :string
  end
end
