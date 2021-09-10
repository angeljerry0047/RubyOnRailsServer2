class CreateCertifications < ActiveRecord::Migration
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.integer :certification_type_id

      t.timestamps
    end
  end
end
