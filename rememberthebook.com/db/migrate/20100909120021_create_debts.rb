class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      
      t.integer :creditor_id
      t.string  :creditor_name
      t.string  :creditor_email
      
      t.boolean :is_creditor_confirmed, :null => false, :default => false
      t.datetime :creditor_confirmed_at
      
      t.string  :thing, :null=>false
      t.date    :should_back_at

      t.integer :debtor_id
      t.string  :debtor_name
      t.string  :debtor_email

      t.boolean :is_debtor_confirmed, :null => false, :default => false
      t.datetime :debtor_confirmed_at
      
      t.timestamps
    end

    add_index :debts, :debtor_id, :unique => false
    add_index :debts, :creditor_id, :unique => false
  end
  
  def self.down
    drop_table :debts
  end
end
