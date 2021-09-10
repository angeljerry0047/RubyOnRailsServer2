class CreateWebcastFacilitators < ActiveRecord::Migration
  def change
    create_table :webcast_facilitators do |t|
      t.string :email
      t.string :access_token
      t.string :organizer_key

      t.timestamps
    end
  end
end
