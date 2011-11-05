class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :company_id, :null=>false
      t.integer :city_id
      t.string :address, :null=>false
      t.string :post_index
      t.text :parsed_address
      t.text :ymaps

      t.timestamps
    end
    
    add_index :addresses, [:address,:company_id], :unique=>true
    remove_column :companies, :address
    remove_column :companies, :ymaps
    remove_column :companies, :parsed_address
  end

  def self.down
    drop_table :addresses
    add_column :companies, :address, :string
    add_column :companies, :ymaps, :string
    add_column :companies, :parsed_address, :string
  end
end
