class CreateStrelkis < ActiveRecord::Migration
  def self.up
    create_table :strelkis do |t|
      t.references :place
      t.references :event

      t.timestamps
    end
  end

  def self.down
    drop_table :strelkis
  end
end
