class ActsAsTaggableMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string    :name,            :null => false, :length => 100
      t.integer   :taggings_count,  :null => false, :default => 0
    end
    
    create_table :taggings do |t|
      t.integer   :tag_id
      t.integer   :taggable_id
      t.string    :taggable_type
      
      t.timestamps
    end

    create_table :tags_synonyms do |t|
      t.integer   :tag_id,        :null => false
      t.integer   :synonym_id,    :null => false
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
