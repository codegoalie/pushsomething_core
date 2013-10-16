class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.string :collapse_key

      t.datetime :created_at
    end

    create_table :notifications_receivers do |t|
      t.integer :notification_id
      t.integer :receiver_id
    end
  end
end
