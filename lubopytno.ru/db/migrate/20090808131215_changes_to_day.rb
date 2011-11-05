class ChangesToDay < ActiveRecord::Migration
  def self.up
    remove_column :days, :is_passed
    add_column :days, :is_passed, :boolean, :null=>false, :default=>false
    
    remove_column :days, :is_holiday
    add_column :days, :is_holiday, :boolean, :null=>false, :default=>false
  end

  def self.down
#    add_column :days, :is_holiday, :boolean
  end
end
