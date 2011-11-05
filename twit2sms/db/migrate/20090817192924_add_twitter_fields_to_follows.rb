class AddTwitterFieldsToFollows < ActiveRecord::Migration
  def self.up
    add_column :follows, :twitter_fields, :text
  end

  def self.down
    remove_column :follows, :twitter_fields
  end
end
