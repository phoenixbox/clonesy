class CollectionProducts < ActiveRecord::Migration
  def change
    create_table :collection_products do |t|
      t.references :collection
      t.references :product
    end
    add_index :collection_products, :collection_id
    add_index :collection_products, :product_id
  end
end
