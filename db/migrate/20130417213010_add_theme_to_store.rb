class AddThemeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :theme, :string, default: 'default'
  end
end
