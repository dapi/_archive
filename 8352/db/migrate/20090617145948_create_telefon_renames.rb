# -*- coding: utf-8 -*-
class CreateTelefonRenames < ActiveRecord::Migration
  def self.up
    create_table :telefon_renames do |t|
      t.string :oldphone
      t.string :newphone
      t.date   :rename_date # Дата переименования. 
      t.timestamps
    end
    
    add_index :telefon_renames, :oldphone, :unique=>true
    add_index :telefon_renames, :newphone, :unique=>true
  end

  def self.down
    drop_table :telefon_renames
  end
end
