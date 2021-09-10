class AddTitleToMetaGroup < ActiveRecord::Migration
  def change
    add_column :meta_groups, :title, :string
  end
end
