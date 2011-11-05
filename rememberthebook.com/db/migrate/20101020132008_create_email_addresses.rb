class CreateEmailAddresses < ActiveRecord::Migration

  def self.up
    create_table :email_addresses do |t|
      t.integer :user_id, :null => false
      t.string :email, :null => false
      t.boolean :is_main, :null => false, :default=>false

      t.timestamps
    end

    add_index :email_addresses, [:user_id, :email], :unique=>true
    add_index :email_addresses, :email


  
    if User.column_names.include? 'email'
      raise "PROBLEM! User does not have 'has_many_emails'. Insert it before usage." unless User.respond_to? :has_many_emails
      User.all.each do |user|
        user.add_email user.attributes['email']
      end
    end
  
      
  end

  def self.down

    drop_table :email_addresses
     
  end

end
