def seed_products(store, count)
  count.times do |i|
    begin
      puts "Seeding product #{i} for store #{store.id}"
      if store.name == 'Bike'
        title = "Bicycle Wine Rack #{i}"
        desc = "If you like wine and you like biking, you're going to love this. The handmade leather bicycle wine rack is perfect for taking wine with you on the go."
      elsif store.name == 'Bracelet'
        title = "Paracord Bracelet #{i}"
        desc = "This is a Customizable Paracord Bracelet in Cobra Weave with an Infinity Charm attached. It is made with a curved black buckle. The finished bracelet will contain at least 8 feet of total paracord."
      end

      store.products.create!(title: title,
                             description: desc,
                             status: 'active',
                             price: rand(2000) + 1)
    rescue
      puts "Product name taken! Retrying."
      retry
    end
  end
end

def seed_categories(store, count)
  count.times do |i|
    begin
      title = Faker::Lorem.words(2).join(" ")
      store.categories.create!(title: title,
                               store_id: store.id)
      puts "Category #{title} created for Store #{store.id}"
    rescue
      puts "Category name taken! Retrying."
      retry
    end
  end
end


def seed_users(count)
  count.times do |i|
    puts "seeding user #{i}"
    User.create!(full_name: "full_name#{i}",
                 password: "password",
                 password_confirmation: "password",
                 email: "user#{i}@example.com",
                 display_name: "display_name#{i}")
  end
end

# THE USUAL SUSPECS / UBERS
user1 = User.create(full_name: "Jeff", email: "demoXX+jeff@jumpstartlab.com", password: "password", display_name: "j3")
user1.uber_up
user2 = User.create(full_name: "Steve Klabnik", email: "demoXX+steve@jumpstartlab.com", password: "password", display_name: "SkrilleX")
user2.uber_up

# CREATE STORES
store1 = Store.create!(name: "Bike", path: "bikes", description: "One word: Biketastic")
store2 = Store.create!(name: "Bracelet", path: "bracelets", description: "Our Bracelets will make you cry with joy")
# store3 = Store.create!(name: "Paul's PB&Js", path: "pbj", description: "peanut-butter-jelly-time")
# store4 = Store.create!(name: "Raphael's Rickshaws", path: "rick-roll-rickshaws", description: "rick roll up in this!")
# store5 = Store.create!(name: "George's Cool Market", path: "cool-market", description: "it's market time")
# store6 = Store.create!(name: "Burger Master", path: "burger-master", description: "the king of burgers")
# store7 = Store.create!(name: "Ice Cream Galore", path: "ice-cream-galore", description: "we loves us some ice cream")
# store8 = Store.create!(name: "Wendy's Magical Den", path: "wendys", description: "The queen of magical Dens")
# store9 = Store.create!(name: "McGonal's Goo", path: "gooey-goo", description: "sticky icky icky")
# store10 = Store.create!(name: "Mike's Soft Lemonade", path: "soft-lemonade", description: "there can be only one")

stores = [store1, store2] #, store3, store4, store5, store6, store7, store8, store9, store10]

# SET STORE STATUS
store1.update_attributes({status: 'online'}, as: :uber)
store2.update_attributes({status: 'online'}, as: :uber)
# store3.update_attributes({status: 'online'}, as: :uber)
# store4.update_attributes({status: 'declined'}, as: :uber)
# store5.update_attributes({status: 'declined'}, as: :uber)
# store 6-8 are pending by default
# store9.update_attributes({status: 'offline'}, as: :uber)
# store10.update_attributes({status: 'offline'}, as: :uber)

# CREATE CATEGORIES
# stores.each { |store| seed_categories(store, 10) }

# CREATE PRODUCTS
stores.each { |store| seed_products(store, 20) }

# CREATE USERS
# seed_users(100)

# CREATE ROLES
# stores.each do |store|
#   ['admin', 'admin'].each do |role|
#     begin
#       UserStoreRole.create({user_id: rand(10_000),
#                             store_id: store.id,
#                             role: role}, as: :uber)
#     rescue
#       puts "Oy Vey! UserStoreRole exists. Retrying."
#       retry
#     end
#   end
# end

# CREATE ORDERS
# STATUSES = ['pending', 'shipped', 'cancelled', 'returned', 'paid']
# stores.each do |store|
#   20.times do |i|
#     begin
#       puts "Seeding order #{i} for store #{store.id}"
#       order = Order.create(status: STATUSES.sample,
#                            user_id: rand(10_000),
#                            store_id: store.id)
#       product = store.products.sample
#       order.order_items.create(product_id: product.id,
#                                unit_price: product.price,
#                                quantity: rand(5))
#     rescue
#       retry
#     end
#   end
# end
