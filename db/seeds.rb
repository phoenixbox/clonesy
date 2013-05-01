SEED_DATA = YAML.load_file('db/seeds.yml')

def seed_products(store)
  SEED_DATA['products'][store.path].each_with_index do |product_params, i|
    puts "Seeding product #{i+1} for store #{store.id}"

    image_params = product_params.delete('images')

    product = store.products.new(product_params)

    image_params.each do |image_param|
      product.images.new(data: URI.parse(image_param['url']))
    end

    product.save!
  end
end

# def seed_categories(store, count)
#   count.times do |i|
#     title = Faker::Lorem.words(2).join(" ")
#     store.categories.create!(title: title,
#                              store_id: store.id)
#     puts "Category #{title} created for Store #{store.id}"
#   end
# end

# THE USUAL SUSPECS / UBERS
user1 = User.create(full_name: "Jeff", email: "demoXX+jeff@jumpstartlab.com", password: "password", display_name: "j3")
user1.uber_up
Collection.create(name: "favorites", user: user1)
user2 = User.create(full_name: "Steve Klabnik", email: "demoXX+steve@jumpstartlab.com", password: "password", display_name: "SkrilleX")
user2.uber_up
Collection.create(name: "favorites", user: user2)

# CREATE STORES
stores = SEED_DATA['stores'].map do |store_params|
           Store.create!(store_params)
         end

# SET STORE STATUS
stores.each do |store|
  store.update_attributes({status: 'online'}, as: :uber)
end

# CREATE CATEGORIES
# stores.each { |store| seed_categories(store, 10) }

# CREATE PRODUCTS
stores.each { |store| seed_products(store) }

# CREATE ORDERS
STATUSES = ['pending', 'shipped', 'cancelled', 'returned', 'paid']
stores.each do |store|
  30.times do |i|
    begin
      puts "Seeding order #{i} for store #{store.id}"
      order = Order.create(status: STATUSES.sample,
                           user_id: rand(100),
                           store_id: store.id)
      product = store.products.sample
      order.order_items.create(product_id: product.id,
                               unit_price: (75..150).to_a.sample,
                               quantity: (1..3).to_a.sample)
    rescue
      retry
    end
    OrderItem.all.each { |i| i.created_at += (rand(20) * -1).days; i.save }
  end
end
