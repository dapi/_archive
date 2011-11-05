class RemoveStorageFromSource < ActiveRecord::Migration
  def self.up
#     remove_column	:sources, :storage_id
     remove_column	:results, :storage_id
     drop_table :storages	
  end

  def self.down
     # вроде как вызывать 20090610002943_create_storages.rb
#     add_column	:storage_id, :integer
  end
end
