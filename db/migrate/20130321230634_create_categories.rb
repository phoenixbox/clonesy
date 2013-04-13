class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :store
      t.string :title

      t.timestamps
    end
  end
end
