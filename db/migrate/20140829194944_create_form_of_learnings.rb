class CreateFormOfLearnings < ActiveRecord::Migration
  def change
    create_table :form_of_learnings do |t|
      t.string	:name
      t.boolean	:recommendable

      t.timestamps
    end
  end
end
