class AddSourceToResultCategories < ActiveRecord::Migration
  def self.up
  add_column	:result_categories, :source_id, :integer
  remove_index    :result_categories, [:category_id, :result_id]
  add_index     :result_categories, [:source_id, :category_name], :unique => true
  add_index     :result_categories, [:source_id, :category_id]
  end

  def self.down
  remove_column	:result_categories, :source_id
  end
end
