class AddAcknowledgementsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :acknowledged_at, :datetime
    add_column :notifications, :acknowledger_id, :integer
  end
end
