class AlterPhoneIndex < ActiveRecord::Migration
  def self.up
    remove_index :phones, :number
    add_index :phones, [:number,:company_id], :unique => true
  end

  def self.down
    add_index :phones, :number
    remove_index :phones, [:number,:company_id]
  end
end
