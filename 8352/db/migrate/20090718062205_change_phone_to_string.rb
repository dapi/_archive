class ChangePhoneToString < ActiveRecord::Migration
  def self.up
  	change_column :phones, :number, :string
	add_column    :phones, :is_fax, :boolean, :null=>false, :default=>false
  end

  def self.down
	remove_column    :phones, :is_fax
  	change_column :phones, :number, :number
  end
end
