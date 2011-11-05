class AddCountersToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :parents_count, :integer, :null=>false, :default=>0
#    add_column :categories, :children_count, :integer, :null=>false, :default=>0
  end

  def self.down
    remove_column :categories, :parents_count
#    remove_column :categories, :children_count
  end
end
