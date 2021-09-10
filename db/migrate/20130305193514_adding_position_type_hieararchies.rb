class AddingPositionTypeHieararchies < ActiveRecord::Migration
  def change
    create_table :position_type_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... competency
      t.integer  :descendant_id, :null => false # ID of the target competency
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" selects:
    add_index :position_type_hierarchies, [:ancestor_id, :descendant_id], :unique => true, :name => "p_t_hierarchies_ancestor_descent"

    # For "all ancestors of…" selects
    add_index :position_type_hierarchies, [:descendant_id], :name => "p_t_hierarchies_descent"
  end
end
