class AddingJoinTablesForCompetenciesAndPassions < ActiveRecord::Migration
  def change
    create_table :passions_users, :id => false do |t|
      t.integer :user_id
      t.integer :passion_id
    end
    
    create_table :competencies_users, :id => false do |t|
      t.integer :user_id
      t.integer :competency_id
    end
    
    add_index :passions_users, :user_id
    add_index :passions_users, :passion_id
    
    add_index :competencies_users, :user_id
    add_index :competencies_users, :competency_id
  end
end
