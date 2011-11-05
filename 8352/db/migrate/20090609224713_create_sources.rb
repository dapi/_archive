class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :target_url, :grabber_module, :description

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
