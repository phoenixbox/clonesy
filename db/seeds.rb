# CREATE STORES
store1 = Store.create!(name: "Brad's Bean Bags", path: "bean-bags-galore", description: "the bestest bean bags")
store2 = Store.create!(name: "Jorge's Tortiallas", path: "tortilla-palace", description: "get yo tortilla on!")

store1.update_attributes({status: 'online'}, as: :uber)
store2.update_attributes({status: 'online'}, as: :uber)

store1.products.create!(title: "title",
                         description: "desc",
                         status: 'active',
                         price: rand(2000) + 1)

store1.products.create!(title: "title_2",
                         description: "desc",
                         status: 'active',
                         price: rand(2000) + 1)

store1.products.create!(title: "title_3",
                         description: "desc",
                         status: 'active',
                         price: rand(2000) + 1)

store1.products.create!(title: "title_4",
                         description: "desc",
                         status: 'active',
                         price: rand(2000) + 1)