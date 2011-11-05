# -*- coding: undecided -*-
class RemoveTypeFromDebts < ActiveRecord::Migration
  def self.up
    remove_column :debts, :type # И зачем я его создавал?
  end

  def self.down
    add_column :debts, :type, :string
  end
end
