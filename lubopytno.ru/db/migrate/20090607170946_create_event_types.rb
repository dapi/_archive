class CreateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string :name, :null => false, :length => 200

      t.timestamps
    end
    
#    add_index :event_types, :event_types_id
  end

  def self.down
    drop_table :event_types
  end
end
