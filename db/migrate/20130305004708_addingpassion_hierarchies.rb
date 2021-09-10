class AddingpassionHierarchies < ActiveRecord::Migration
  def change
    create_table :passion_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... competency
      t.integer  :descendant_id, :null => false # ID of the target competency
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" selects:
    add_index :passion_hierarchies, [:ancestor_id, :descendant_id], :unique => true

    # For "all ancestors of…" selects
    add_index :passion_hierarchies, [:descendant_id]
  end
end
