class AddNicknameToReceivers < ActiveRecord::Migration
  def change
    add_column :receivers, :nickname, :string
  end
end
