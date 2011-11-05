# -*- coding: utf-8 -*-
# require 'validations'
class Debt < ActiveRecord::Base
  
  # attr_accessible :thing, :debtor_name, :debtor_email, :creditor_name, :creditor_email,
  #                 :till, :state, :notify_debtor, :notify_creditor
  # debtor_attributes      
  
  belongs_to :creditor, :class_name => 'User',
             :foreign_key => :creditor_id, :include => true, :counter_cache => true
  belongs_to :debtor, :class_name => 'User', :foreign_key => :debtor_id,
             :include => true, :counter_cache => true

  # Владелец записи
  belongs_to :user, :include => true

  # validates :till, :presence => true
  validates :thing, :presence => true
  
  validate :load_exist_partner # Должно быть до nested и не получается сделать фильтрами
  
  accepts_nested_attributes_for :debtor, :creditor

  # validates :debtor_id, :presence=>true, :existence=>true
  # validates :creditor_id, :presence=>true, :existence=>true
  validates :creditor, :presence => true
  validates :debtor, :presence => true

  validate :set_user        # Устанавливаем self.user
  validate :must_be_unique   # Должно быть после nested

  validate :check_closed

  
  scope :overdues, where( "till<=?", Date.today() )
  scope :actual, where( :state => 'open' )  # На open cucumber вылетает, пытаясь открыть файл
  scope :closed, where( :state => 'closed' )
  scope :accepted, where( :accept_state => 'accepted' )
  scope :declined, where( :accept_state => 'declined' )

  default_scope order('till, created_at')

  # Долги по которым пора рассылать напоминалки
  scope :overdues_to_notify, actual.overdues.where( :debtor_notified_at => nil)

  before_save :check_changes
  before_create :accept_if_debt
  
  after_create :notify_partners
  
  after_save :create_contacts

  state_machine :accept_state, :initial => :wait do 
    state :wait, :accepted, :declined
    
    event :accept do
      transition any => :accepted
    end
    
    event :decline do
      transition :wait => :declined
    end
    
    event :renew do
      transition :declined => :wait
    end
    
    after_transition any => [ :declined, :accepted ] do |debt|
      debt.update_attribute(:accepted_at, Time.now());
    end

    after_transition any => :accepted do |debt|
      # Не надо оповещать если это дебитор сам создал свой долг
      Notifier::Creditor.accepted( debt ).deliver unless debt.new_record?
    end

    after_transition any => :declined do |debt|
      Notifier::Creditor.declined( debt ).deliver      
    end
    
    after_transition :declined => :wait do |debt|
      debt.send_confirm
    end
  end

  
  state_machine :initial => :open do
    state :open, :closed
    
    event :close do
      transition any => :closed 
    end
    
    before_transition any => :closed do |debt|
      debt.closed_at = Time.now()
    end
  end


  # Напомним должникам о долге, вызывается из шедуллера
  def self.notify_overdues
    # overdues_to_notify.map(&:notify_debtor)
    all.map(&:notify_overdue)
  end

  # Загружаем партнера по емайлу если он уже есть в нашей базе
  def load_exist_partner
    # return unless new_record?
    if is_credit?
      return unless debtor
      if debtor.persisted?
      elsif debtor.email? && debtor_temp = User.find_by_email( debtor.email.downcase )
        self.debtor = debtor_temp
      else
        self.debtor.state = 'virtual'
      end
    else
      return unless creditor
      if creditor.persisted?
      elsif creditor.email? && creditor_temp = User.find_by_email( creditor.email.downcase )
        self.creditor = creditor_temp
      else
        self.creditor.state = 'virtual'
      end
    end
  end


  # Нужно вернуть контакт. Создадим его, если требуется
  def contact
    self.user.contacts.find_or_create_by_partner_id partner.id 
  end

  def create_contacts
    self.partner.contacts.find_or_create_by_partner_id user.id
    contact
  end

  # Проверяем не вводили ли уже точно такой-же кредит
  def must_be_unique
    return true unless new_record?

    
    # Debt.exists?(
    #              :thing=>thing,
    #              :creditor_id=>creditor_id,
    #              :debtor_id=>debtor_id,
    #              :till=>till
    #              )  and
    #   errors.add( :thing, "Точно такой долг уже есть в Вашей базе")

    # errors.add("debtor.name", "debtor.name")

    if creditor_id == debtor_id && !creditor_id.nil?
      wrong_user = is_credit? ? debtor : creditor
      wrong_user.errors.add(:email,
                         "Вы оформляете долг у самого себя" ) #  if partner_id # Anti-cucumber

      # Без этого валидация прокатывает
      errors.add(is_credit? ? 'debtor.email' : 'creditor.email',
                         "Вы оформляете долг у самого себя" )
    end
  end

  def check_closed
    self.errors.add(:all, "Долг погашен. Изменять его нельзя." ) if
      self.closed? && !self.changed.empty? && self.changed.none? { |a| a=='state' }
  end

  def accept_if_debt
    # Если мы оформляем долг, то значит мы его автоматом подтверждаем
    unless is_credit?
      self.accept_state = "accepted"
      self.accepted_at = Time.now()
    end
  end

  # Оповещаем партнеров о создании на них записей
  def notify_partners
    if is_credit?
      send_confirm # Предупреждаем должника, а если он виртуал, то сообщаем и регистрации
    else
      Notifier::Creditor.record_created( self ).deliver
    end
  end

  
  # Оповещаем должника, что ему нужно подтвердить долг
  # forced - значит кредитор поросил почторно выслать письмо с веб-интерфейса
  def send_confirm( force = false )
    raise "Ошибка #1" unless is_credit?
    Notifier::Debtor.confirm( self, force ).deliver
  end
  

  def set_user
    self.user = is_credit? ? creditor : debtor if new_record?
  end
  
  def check_changes
    # Если был откланен, но что-то изменить, то статус меняеться на wait и снова рассылается оповещение
    renew if declined? && changed? && changed.exclude?("accept_state")
  end

  def to_s
    thing
  end

  # Действуем как одалживатель
  def is_credit?
    self.class == Credit
  end


  # TODO Проверить все использования partner
  def partner
    # Не надежно, так как на ранних стадиях еще нет user
    # self.user == self.creditor ? self.debtor : self.creditor

    # Не верно определяет если кредит создал дебитор
    # is_credit? ? self.debtor : self.creditor

    user_id==debtor_id ? creditor : debtor
  end
  
  def partner_id
    user_id==debtor_id ? creditor_id : debtor_id

  end

  # Количество дней просрочки, только для открытых позиций
  def overdue
    return 0 unless till
    diff = ( open? ? Date.today() : closed_at.to_date ) - till
    diff < 0 ? 0 : diff
  end

  # Есть просрочка?
  def is_overdue?
    overdue!=0
  end

  def notify_overdue
    update_attribute( :debtor_notified_at, Time.now() )
    Notifier::Debtor.overdue( self ).deliver
    Notifier::Creditor.overdue( self ).deliver
  end
  
end
