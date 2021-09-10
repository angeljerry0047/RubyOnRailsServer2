class AddAwardableToCertificationTypes < ActiveRecord::Migration
  def change
    add_column :certification_types, :awardable, :boolean
  end
end
