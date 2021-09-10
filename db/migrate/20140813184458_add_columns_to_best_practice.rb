class AddColumnsToBestPractice < ActiveRecord::Migration
  def change
    add_column :best_practices, :emb_link, :text
    add_column :best_practices, :ext_link, :text
    add_column :best_practices, :documents, :string
    add_column :best_practices, :audio, :string
    add_column :best_practices, :link_title, :string
  end
end
