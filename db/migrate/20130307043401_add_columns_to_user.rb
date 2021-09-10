class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :description, :text
    add_column :users, :image, :string
    add_column :users, :headline, :string
    add_column :users, :industry, :string
  end
end
