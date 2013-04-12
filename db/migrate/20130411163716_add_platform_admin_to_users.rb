class AddPlatformAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :platform_admin, :boolean
  end
end
