class AddUberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uber, :boolean, default: false
  end
end
