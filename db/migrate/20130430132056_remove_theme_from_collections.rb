class RemoveThemeFromCollections < ActiveRecord::Migration
 def change
  remove_column :collections, :theme
 end
end
