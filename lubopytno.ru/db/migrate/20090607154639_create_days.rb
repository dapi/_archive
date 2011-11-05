class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.date :date,       :null => false
      t.integer :counter,       :null => false, :default => 0
      t.boolean :is_passed,       :null => false
      t.boolean :is_holiday,       :null => false

      t.timestamps
    end
    
   add_index :days, :date, :unique => true
  end

  def self.down
    drop_table :days
  end
end
