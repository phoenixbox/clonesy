class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user
      t.references :store
      t.string :status
      t.string :guid

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :guid, unique: true
  end
end
