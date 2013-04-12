class CreateUserStoreRoles < ActiveRecord::Migration
  def change
    create_table :user_store_roles do |t|
      t.references :store_id
      t.references :user_id
      t.string :role

      t.timestamps
    end
    add_index :user_store_roles, :store_id_id
    add_index :user_store_roles, :user_id_id
  end
end
