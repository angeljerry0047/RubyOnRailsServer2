class RenamingCompetencyGroupToQuestionGroup < ActiveRecord::Migration
  def change
    remove_column :questions, :group
    
    drop_table :competency_groups
    
    create_table :question_groups do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
