class AddPlaceTypeToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :place_type_id, :integer
  end

  def self.down
    remove_column :places, :place_type_id
  end
end
