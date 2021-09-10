class CreateDevelopedCompetencies < ActiveRecord::Migration
  def change
    create_table :developed_competencies do |t|
      t.text :description
      t.integer :competency_id
      t.integer :opportunity_id
    end
    
    add_index :developed_competencies, :competency_id
    add_index :developed_competencies, :opportunity_id
  end
end