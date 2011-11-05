class AddPlaceCounterToPlaceType < ActiveRecord::Migration
  def self.up
    add_column :place_types, :places_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :place_types, :places_count
  end
end
