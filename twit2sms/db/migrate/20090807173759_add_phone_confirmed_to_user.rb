class AddPhoneConfirmedToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_confirmed, :boolean, :null=>false, :default=>false
  end

  def self.down
    remove_column :users, :phone_confirmed
  end
end
