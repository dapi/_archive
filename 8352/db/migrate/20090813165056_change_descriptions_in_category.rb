class ChangeDescriptionsInCategory < ActiveRecord::Migration
  def self.up
    change_column :categories, :description, :text, :null=>true
    change_column :categories, :parents_count, :integer, :null=>false, :default=>0
    change_column :categories, :children_count, :integer, :null=>false, :default=>0
  end

  def self.down
  end
end
