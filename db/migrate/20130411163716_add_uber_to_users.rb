class AddUberToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin
    add_column :users, :uber, :boolean, default: false
  end
end
