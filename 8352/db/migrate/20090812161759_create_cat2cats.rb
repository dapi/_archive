class CreateCat2cats < ActiveRecord::Migration
  def self.up
    create_table :cat2cats do |t|
      t.integer     :parent_id, :null => false
      t.integer     :child_id, :null => false
    end
    
    add_index :cat2cats, [:parent_id, :child_id], :unique=>true
    add_index :cat2cats, [:child_id, :parent_id]
  end

  def self.down
    drop_table :cat2cats
  end
end
