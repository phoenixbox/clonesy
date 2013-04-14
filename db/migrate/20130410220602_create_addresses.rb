class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :state
      t.string :zipcode
      t.string :city
      t.string :type

      t.references :user

      t.timestamps
    end
    add_index :addresses, [:user_id, :type], unique: true
  end
end
