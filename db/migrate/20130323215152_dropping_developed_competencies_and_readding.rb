class DroppingDevelopedCompetenciesAndReadding < ActiveRecord::Migration
  def change
    remove_index :developed_competencies, :competency_id
    remove_index :developed_competencies, :opportunity_id
    drop_table :developed_competencies
    
    
    create_table :developed_competencies do |t|
      t.integer :competency_id
      t.integer :opportunity_id
    end
    
    add_index :developed_competencies, :competency_id
    add_index :developed_competencies, :opportunity_id
  end
end
