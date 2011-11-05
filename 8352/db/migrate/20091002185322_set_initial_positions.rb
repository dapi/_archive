class SetInitialPositions < ActiveRecord::Migration
  def self.up
    BranchCompanyGroup.all(:order => "position ASC").each_with_index do |bc, idx|
      bc.position = idx
      bc.save!
    end
  end

  def self.down
  end
end
