# -*- coding: utf-8 -*-
class AddIndexToCity < ActiveRecord::Migration
  def self.up
    
    # Город, владелец префикса
    add_column :cities, :is_prefix_owner, :boolean, :null=>false, :default=>true
    
    
    add_index :cities, :name, :unique=>true
    add_index :cities, [:prefix, :is_prefix_owner]
    
  end

  def self.down
    remove_column :cities, :is_prefix_owner
    remove_index :cities, [:prefix, :is_prefix_owner]
    remove_index :cities, :name
  end
end
