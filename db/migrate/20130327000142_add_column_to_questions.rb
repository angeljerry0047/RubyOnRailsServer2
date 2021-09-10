class AddColumnToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :question_group_id, :integer
  end
end
