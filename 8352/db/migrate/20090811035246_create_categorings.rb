class CreateCategorings < ActiveRecord::Migration
  def self.up
    create_table :categorings do |t|
      t.integer :category_id, :null=>false
      t.integer :categorable_id, :null=>false
      t.string :categorable_type, :null=>false

      t.timestamps
    end
    
    add_index :categorings, :category_id
    add_index :categorings, [:categorable_type,:categorable_id]
  end

  def self.down
    drop_table :categorings
  end
end
