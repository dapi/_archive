class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.references  :category
      
      t.string      :name,          :null => false, :length => 200
      t.string      :full_name,     :null => false, :length => 1024
      t.integer     :inn
      t.string      :address,       :length => 200
      t.string      :site,          :length => 32
      t.string      :director,      :length => 150
      t.text        :description
      t.string      :working_time,  :length => 200
      t.string      :sources,       :length => 1024
      
      t.timestamps
    end
    add_index :companies, :category_id
  end

  def self.down
    drop_table :companies
  end
end
