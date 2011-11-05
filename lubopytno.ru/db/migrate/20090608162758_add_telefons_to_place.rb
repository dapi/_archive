class AddTelefonsToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :telefons, :string
    add_column :places, :desc, :text
  end

  def self.down
    remove_column :places, :telefons
    remove_column :places, :desc
  end
end
