class RenameCat2catsToCategoriesCategories < ActiveRecord::Migration
  def self.up
    rename_table :cat2cats, :categories_categories
  end

  def self.down
    rename_table :categories_categories, :cat2cats
  end
end
