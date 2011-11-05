class RemoveEmailsConstraintFromUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :email, :string, :null=>true, :default=>''
  end

  def self.down
    change_column :users, :email, :string, :null=>false
  end
end
