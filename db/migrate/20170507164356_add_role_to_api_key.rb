class AddRoleToApiKey < ActiveRecord::Migration
  def change
    add_column :api_keys, :role, :integer
  end
end
