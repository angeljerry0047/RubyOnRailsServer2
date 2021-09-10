class AddMuteNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :mute_notifications, :boolean, :default => false
  end
end
