class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :subject, :null=>false
      t.date :date, :null=>false
      t.time :time
      t.references :event_type, :null=>false
      t.references :day, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
