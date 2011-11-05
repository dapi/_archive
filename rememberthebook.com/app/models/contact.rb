# -*- coding: utf-8 -*-
class Contact < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :partner, :include=>true, :class_name => 'User'

  validates :user, :presence=> true
  validates :partner, :presence=> true

  # Ага, именно так
  validates :partner_id, :uniqueness=>{ :scope=>:user_id }

  # Долги партнера
  def debts
    Debt.where( :debtor_id=>partner_id, :creditor_id=>user_id )
  end

  # Одолжения партнера
  def credits
    Credit.where( :debtor_id=>user_id, :creditor_id=>partner_id )
  end

  def to_s
    partner
  end
  
end
