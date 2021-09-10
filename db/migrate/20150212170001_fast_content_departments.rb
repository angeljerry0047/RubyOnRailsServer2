class FastContentDepartments < ActiveRecord::Migration
  def change
    create_table :fast_content_departments, :id => false do |t|
      t.integer :fast_content_id
      t.integer :department_id
    end

    add_index :fast_content_departments, :fast_content_id
    add_index :fast_content_departments, :department_id
  end
end
