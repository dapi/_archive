# -*- coding: utf-8 -*-
class Ability
  include CanCan::Ability
  
  def initialize(user)
    # user ||= User.new # guest user

    return unless defined? user

    can :create, [Credit, Debt]

    # if user.admin?
    #   can :manage, :all
    # can :read, :all
    # alias_action :index, :show, :to => :read
    # alias_action :new, :to => :create
    # alias_action :edit, :to => :update
    # alias_action :update, :destroy, :to => :modify
    

    can :read, [Credit, Debt], :partner_id => user.id

    can [:read, :destroy], [Credit, Debt], :user_id => user.id

    can :update, [Credit, Debt], :user_id => user.id, "accepted?" => false, "open?" => true

    can :close, [Credit, Debt], :user_id => user.id
    can :close, [Credit, Debt], :creditor_id => user.id
    
    can :send_confirm, Credit, :user_id => user.id, "wait?" => true, "open?" => true
    
    #cannot :manage, User, :self_managed => true
    
    can :confirm, Debt, :debtor_id => user.id, "accepted?" => false, "open?" => true # self.partner == user && !self.accepted?

  end
  
end
