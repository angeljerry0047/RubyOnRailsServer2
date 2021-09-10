class CreateDeliveryCompetencies < ActiveRecord::Migration
  def change
    create_table :delivery_competencies do |t|
      t.integer :opportunity_category_id
      t.integer :competency_id

      t.timestamps
    end
  end
end
