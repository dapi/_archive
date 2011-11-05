class AddSynonymNameToTagsSynonym < ActiveRecord::Migration
  def self.up
    add_column :tags_synonyms, :name, :string, :null=>false
    add_index :tags_synonyms, :name, :unique=>true
    add_index :tags_synonyms, :tag_id
    
    remove_column :tags_synonyms, :synonym_id
  end

  def self.down
    remove_column :tags_synonyms, :name
  end
end
