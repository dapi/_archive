class AddIndexToResultCategories < ActiveRecord::Migration
  def self.up
    add_index :result_categories, [:category_name, :source_id], :unique=>true
    add_index :categories, [:name, :parent_id], :unique=>true
  end

  def self.down
    remove_index :result_categories, [:category_name, :source_id]
    remove_index :categories, [:name, :parent_id]
  end
end
