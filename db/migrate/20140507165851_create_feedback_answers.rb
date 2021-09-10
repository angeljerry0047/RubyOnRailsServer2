class CreateFeedbackAnswers < ActiveRecord::Migration
def change
    create_table :feedback_answers do |t|
      t.text :answer

      t.timestamps
    end
  end
end
