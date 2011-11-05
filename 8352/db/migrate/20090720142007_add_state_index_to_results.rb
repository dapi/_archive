class AddStateIndexToResults < ActiveRecord::Migration
  def self.up
    add_index :results, :state
  end

  def self.down
    remove_index :results, :state
  end
end
