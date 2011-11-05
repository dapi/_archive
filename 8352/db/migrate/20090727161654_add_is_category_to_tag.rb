class AddIsCategoryToTag < ActiveRecord::Migration
  def self.up
    add_column :tags, :is_primary, :boolean, :null=>false, :default=>false
  end

  def self.down
    remove_column :tags, :is_primary
  end
end
