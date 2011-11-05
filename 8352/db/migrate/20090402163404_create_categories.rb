class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.references  :category

      t.string      :name,            :null => false, :length => 200
      t.text        :description,     :null => false
      t.integer     :companies_count, :null => false, :default => 0
    end
    
    add_index :categories, :category_id
  end

  def self.down
    drop_table :categories
  end
end
