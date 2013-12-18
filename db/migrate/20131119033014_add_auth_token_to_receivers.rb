class AddAuthTokenToReceivers < ActiveRecord::Migration
  def change
    add_column :receivers, :auth_token, :string

    Receiver.find_each do |receiver|
      receiver.save
    end
  end
end
