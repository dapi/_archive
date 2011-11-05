class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.string    :twitter, :null=>false
      t.integer   :user_id, :null=>false
      t.timestamp :pulled_at
      t.timestamps
    end
    
    add_index :follows, [:twitter, :user_id], :unqiue=>true
  end

  def self.down
    drop_table :follows
  end
end
