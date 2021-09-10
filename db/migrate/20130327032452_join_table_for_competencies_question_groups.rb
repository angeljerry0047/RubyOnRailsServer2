class JoinTableForCompetenciesQuestionGroups < ActiveRecord::Migration
  def change
    create_table :competencies_question_groups, :id => false do |t|
      t.integer :competency_id
      t.integer :question_group_id
    end
    
    add_index :competencies_question_groups, :competency_id
    add_index :competencies_question_groups, :question_group_id
  end
end
