class AddIsMainToBranche < ActiveRecord::Migration
  def self.up
    add_column :branches, :is_main, :boolean, :default=>false, :nullable=>false
  end

  def self.down
    remove_column :branches, :is_main
  end
end
