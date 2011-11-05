class FixPremiseIdInAddress < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :permis_id, :premise_id
  end

  def self.down
    rename_column :addresses, :premise_id, :permis_id
  end
end
