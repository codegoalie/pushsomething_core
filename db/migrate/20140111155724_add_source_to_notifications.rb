class AddSourceToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :source, :string
    add_column :notifications, :source_id, :string
    # add_column :notifications, :source_extras, :json
  end
end
