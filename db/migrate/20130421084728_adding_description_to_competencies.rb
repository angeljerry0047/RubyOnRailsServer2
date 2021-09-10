class AddingDescriptionToCompetencies < ActiveRecord::Migration
  def change
    add_column :competencies, :description, :text
  end
end
