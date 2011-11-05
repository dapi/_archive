class RemoveAuthentications < ActiveRecord::Migration
  def self.up
    drop_table :authentications
    add_index :debts, :user_id
  end

  def self.down
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.timestamps
    end
  end
end
