class RemoveResultFromResultCategories < ActiveRecord::Migration
  def self.up
  	remove_column	:result_categories,	:result_id
  end

  def self.down
  	add_column	:result_categories,	:result_id,	:integer
  end
end
