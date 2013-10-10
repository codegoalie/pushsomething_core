class CreateReceiversTable < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.string :uid, null: false
      t.integer :user_id, null: false
      t.string :gcm_id

      t.timestamps
    end

    add_index :receivers, [:user_id, :uid], unique: true
  end
end
