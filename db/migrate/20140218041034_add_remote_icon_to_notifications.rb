class AddRemoteIconToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :remote_icon, :string
  end
end
