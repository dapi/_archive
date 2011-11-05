class CreateTelefonFederals < ActiveRecord::Migration
  def self.up
    create_table :telefon_federals do |t|
      t.string :federal
      t.string :city
      t.string :operator
      t.timestamps
    end
    add_index :telefon_federals, :federal, :unique=>true
    add_index :telefon_federals, :city, :unique=>true
  end

  def self.down
    drop_table :telefon_federals
  end
end
