class AddCommentToDebts < ActiveRecord::Migration
  def self.up
    add_column :debts, :comment, :text
  end

  def self.down
    remove_column :debts, :comment
  end
end
