class AddQuestionsToFeedback < ActiveRecord::Migration
  def change
  	add_column :feedbacks, :q1, :integer
  	add_column :feedbacks, :q2, :integer
  	add_column :feedbacks, :q3, :integer
  	add_column :feedbacks, :q4, :integer
  	add_column :feedbacks, :q5, :integer
  	remove_column :feedbacks, :body
  end
end
