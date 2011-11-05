class RemoveCategory < ActiveRecord::Migration
  def self.up
    drop_table :categorings
    drop_table :categories_categories
    drop_table :categories
  end

  def self.down
  end
end
