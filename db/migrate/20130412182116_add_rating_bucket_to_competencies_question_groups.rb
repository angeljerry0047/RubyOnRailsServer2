class AddRatingBucketToCompetenciesQuestionGroups < ActiveRecord::Migration
  def change
    add_column :competencies_question_groups, :rating_bucket, :string
  end
end
