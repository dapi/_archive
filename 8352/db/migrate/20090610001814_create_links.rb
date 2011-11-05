class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.references :source, :parent
      t.string  :name, :url
      t.boolean :is_follow, :is_appeared, :default => true
      t.integer :links_count, :default => 0

      t.timestamps
    end
#    index for: url, source_id, name
  end

  def self.down
    drop_table :links
  end
end
