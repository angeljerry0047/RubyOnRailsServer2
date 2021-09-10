class AddHowThisIdeaHelpedToBestPractice < ActiveRecord::Migration
  def change
    add_column :best_practices, :idea_help, :text
  end
end
