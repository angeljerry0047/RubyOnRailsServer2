class AddColumnToDevelopedCompetencies < ActiveRecord::Migration
  def change
    add_column :developed_competencies, :description, :text
  end
end