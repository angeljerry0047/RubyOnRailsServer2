class CreateCompetencyGroups < ActiveRecord::Migration
  def change
    create_table :competency_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
