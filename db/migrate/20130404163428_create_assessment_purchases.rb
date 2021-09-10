class CreateAssessmentPurchases < ActiveRecord::Migration
  def change
    create_table :assessment_purchases do |t|
      t.integer :assessment_report_id
      t.integer :assessment_id
      t.string :charge_id
      t.integer :user_id

      t.timestamps
    end
  end
end
