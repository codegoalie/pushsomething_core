class AddFacebookCredsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :integer
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_token_expires_at, :integer
  end
end
