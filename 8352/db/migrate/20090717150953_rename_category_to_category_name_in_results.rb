class RenameCategoryToCategoryNameInResults < ActiveRecord::Migration
  def self.up
    rename_column :results, :category, :category_name
    add_column    :results, :result_category_id, :integer
  end

  def self.down
    rename_column :results, :category_name, :category
    remove_column    :results, :result_category_id
  end
end
