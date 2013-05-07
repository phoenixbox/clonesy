json.extract! @product, :title, :description, :price
json.edit_url edit_store_admin_product_path(current_store, @product)



json.store do |json|
  json.(@product.store, :name, :path, :description)
end