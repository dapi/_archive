# -*- coding: utf-8 -*-
class CreateStreets < ActiveRecord::Migration
  def self.up
    create_table :streets do |t|
      t.integer :city_id
      t.integer :premises_count
      t.string :name

      t.timestamps
    end
    add_index :streets, [:city_id,:name], :unique=>true
  end

  def self.down
    drop_table :streets
  end
end
