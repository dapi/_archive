class AddActsAsCategoryForCategories < ActiveRecord::Migration
  def self.up
    add_column    :categories, :parent_id,         :integer
    add_column    :categories, :position,          :integer
    add_column    :categories, :children_count,    :integer
    add_column    :categories, :ancestors_count,   :integer
    add_column    :categories, :descendants_count, :integer
    add_column    :categories, :hidden,            :boolean

    remove_column :categories, :category_id
  end

  def self.down
    remove_column :categories, :parent_id
    remove_column :categories, :position
    remove_column :categories, :children_count
    remove_column :categories, :ancestors_count
    remove_column :categories, :descendants_count
    remove_column :categories, :hidden
                  
    add_column    :categories, :category_id, :integer    
  end
end
