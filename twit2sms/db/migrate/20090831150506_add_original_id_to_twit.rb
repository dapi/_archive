class AddOriginalIdToTwit < ActiveRecord::Migration
  def self.up
    add_column :twits, :original_id, :string
    add_index :twits, :original_id
  end

  def self.down
    remove_index :twits, :original_id
    remove_column :twits, :original_id
  end
end
