class CreateResultCategories < ActiveRecord::Migration
  def self.up
    create_table :result_categories do |t|
      t.string :category_name
      t.references :category
      t.references :result

      t.timestamps
    end
    add_index :result_categories, [:category_id, :result_id], :unique => true
    add_index :result_categories, [:category_name]
  end

  def self.down
    drop_table :result_categories
  end
end
