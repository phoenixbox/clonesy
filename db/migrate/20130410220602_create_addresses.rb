class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :state
      t.string :zipcode
      t.string :city
      t.string :type

      t.belongs_to :addressable, polymorphic: true

      t.timestamps
    end
    add_index :addresses, [:addressable_type, :addressable_id]
  end
end
