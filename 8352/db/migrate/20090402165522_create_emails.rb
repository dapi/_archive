class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.references  :company
      t.string      :email,         :null => false
      t.string      :person,        :length => 150
      t.string      :department,    :length => 300
    end
    
    add_index :emails, :company_id
    add_index :emails, :email, :unique => true
  end

  def self.down
    drop_table :emails
  end
end
