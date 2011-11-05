class AddStateToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :state, :string
    ActiveRecord::Base.connection.update_sql("update results set state='updated' where is_updated");
    ActiveRecord::Base.connection.update_sql("update results set state='imported' where not is_updated");
    remove_column :results, :is_updated
  end

  def self.down
    remove_column :results, :state
    remove_column :results, :is_updated, :boolean
  end
end
