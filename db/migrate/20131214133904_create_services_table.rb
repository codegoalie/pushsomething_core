class CreateServicesTable < ActiveRecord::Migration
  def up
    create_table :services do |t|
      t.integer :user_id
      t.string :name
      t.string :token, limit: 40

      t.timestamps
    end
  end

  def down
    drop_table :services
  end
end
