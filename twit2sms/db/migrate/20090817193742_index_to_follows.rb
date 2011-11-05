class IndexToFollows < ActiveRecord::Migration
  def self.up
    add_index :follows, [:user_id,:twitter], :unique=>true
  end

  def self.down
  end
end
