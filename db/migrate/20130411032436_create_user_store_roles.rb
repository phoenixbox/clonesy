class CreateUserStoreRoles < ActiveRecord::Migration
  def change
    create_table :user_store_roles do |t|
      t.references :store
      t.references :user
      t.string :role

      t.timestamps
    end
    add_index :user_store_roles, [ :store_id, :user_id, :role ], unique: true
    add_index :user_store_roles, :user_id
  end
end
