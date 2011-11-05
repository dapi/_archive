class AddTypeToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :ctype, :string
  end

  def self.down
    remove_column :cities, :ctype
  end
end
