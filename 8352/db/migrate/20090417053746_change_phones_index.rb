class ChangePhonesIndex < ActiveRecord::Migration
  def self.up
    #      t.integer     :number,        :null => false, :precision => 11
    change_column :phones, :number, :bigint
    remove_index :phones, :number
    add_index :phones, :number
  end

  def self.down
    remove_index :phones, :number
    add_index :phones, :number, :unique => true
  end
end
