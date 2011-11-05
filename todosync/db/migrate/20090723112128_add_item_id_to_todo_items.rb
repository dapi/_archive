class AddItemIdToTodoItems < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :item_id, :integer
    add_index  :todo_items, [:remote_application_id, :item_id], :unique=>true
  end

  def self.down
    remove_column :todo_items, :item_id
  end
end
