class CreateTodoItems < ActiveRecord::Migration
  def self.up
    create_table :todo_items do |t|
      t.references :remote_application
      t.string :text
      t.boolean :is_removed

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_items
  end
end
