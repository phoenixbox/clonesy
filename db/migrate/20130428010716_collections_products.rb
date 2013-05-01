class CollectionsProducts < ActiveRecord::Migration
  def change
    create_table :collections_products do |t|
      t.references :collection
      t.references :product
    end

    add_index :collections_products, [:collection_id, :product_id], unique: true
    add_index :collections_products, :product_id
  end
end
