class CreateTwits < ActiveRecord::Migration
  def self.up
    create_table :twits do |t|
      t.integer :follow_id
      t.string :message
      t.timestamp :message_time
      t.timestamp :sent_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :twits
  end
end
