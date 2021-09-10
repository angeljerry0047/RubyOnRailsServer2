class AddColumnToQuestionGroups < ActiveRecord::Migration
  def change
    add_column :question_groups, :assessment_id, :integer
  end
end
