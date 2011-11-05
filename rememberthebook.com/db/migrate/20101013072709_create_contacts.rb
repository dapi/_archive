# -*- coding: utf-8 -*-
class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id      # Владелец записи
      t.integer :partner_id   # Собственно контакт. Ссылка на user

      t.timestamps
    end

    add_index :contacts, [:user_id, :partner_id], :unique=>true

    Debt.all.map { |d|
      d.user.contacts.find_or_create_by_partner_id d.partner.id
      d.partner.contacts.find_or_create_by_partner_id d.user.id
    }
  end

  def self.down
    drop_table :contacts
  end
end
