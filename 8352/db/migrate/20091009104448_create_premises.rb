# -*- coding: utf-8 -*-
class CreatePremises < ActiveRecord::Migration
  def self.up
    create_table :premises do |t|
      t.integer :city_id
      t.integer :street_id
      t.integer :addresses_count # фактически это количество компаний
      
      t.string  :number # номер дома может быть типа 1/2 или 20к1
      
      t.timestamps
    end
    
    add_index :premises, [:city_id,:street_id,:number], :unique=>true
    add_column :addresses, :permis_id, :integer
  end

  def self.down
    drop_table :premises
    remove_column :addresses, :permis_id
  end
end
