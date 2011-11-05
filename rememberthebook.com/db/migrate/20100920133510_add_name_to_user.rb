# -*- coding: utf-8 -*-
class AddNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string

    # Устанавливаем когда создаем пользователя искусственно
    add_column :users, :is_virtual, :boolean, :null=>false, :default=>false
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :is_virtual
  end
end
