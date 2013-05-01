class AddOrdersStoresJoin < ActiveRecord::Migration
  def change
    create_table :orders_stores do |t|
      t.references :order
      t.references :store
    end

    remove_column :orders, :store_id
  end
end
