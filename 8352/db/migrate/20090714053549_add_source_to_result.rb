class AddSourceToResult < ActiveRecord::Migration
  def self.up
  	add_column	:results, :source_id, :integer
	ActiveRecord::Base.connection.update_sql("update results set source_id=(select source_id from links where id=link_id)");
	add_index :results, :source_id
  end

  def self.down
  	remove_column	:results, :source_id
  end
end
