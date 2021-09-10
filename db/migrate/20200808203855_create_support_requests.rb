class CreateSupportRequests < ActiveRecord::Migration
  def change
    create_table :support_requests do |t|
      t.string :name
      t.string :email
      t.text :description
      t.datetime :issue_time
      t.string :ip_address

      t.timestamps
    end
  end
end
