# -*- coding: utf-8 -*-
module ApplicationHelper

  # def omniauth_path( provider, *params)
  #   if Devise.omniauth_configs[provider.to_sym]
  #     "/users/auth/\#{provider}"
  #   else
  #     raise ArgumentError, "Could not find omniauth provider \#{provider.inspect}"
  #   end
  #   # "#{mapping.fullpath}/auth/\#{provider}"
  # end

  def say_days( days )
    days.to_s + " " + Russian.pluralize( days, 'день', 'дня', 'дней' )
  end

  # Показывать имя контакта при отображении долга?
  # Не показываем на страницах долга определенного контакта, он и так есть на верху.
  def show_contact?
    controller_name!='contacts'
    # return true unless defined? @show_contact
    # @show_contact
  end
  
  def red_counter(count, red_count=0)
    # counter=[]
    # counter.push count if count>0
    # counter.push "<span class=\"red\">#{red_count}</span>" if red_count>0
    # text += " (#{counter.join(',')})" unless counter.empty?
    # text.html_safe
    return unless count>0
    counter = " (#{count})"
    counter = "<span class=\"red\" id=\"r\">#{counter}</span>" if red_count>0
    counter.html_safe
  end

  def gravatar( user=current_user, size=42 )
    img_gravatar( user.email || 'noavatar@rememberthebook.com',
                  { :size=>size, :alt=>user.to_s } ).html_safe
  end

  # def userpic( user=current_user, size=24 )
  #   return if user.blank?
  #   content_tag :span, :class => 'userpic' do
  #     img_gravatar( user.email, { :size=>size, :alt=>user.to_s } )
  #     content_tag :span, :class => 'nick' do
  #       user.to_s
  #     end
  #   end
  # end

  def close_record_path( record, return_to )
    record.is_credit? ? close_credit_path(record, :return_to=>return_to) : close_debt_path(record, :return_to=>return_to)
  end


  def navigation( label, url, active, chosen=nil, title=nil )
    stateful_link_to(
                     active,
                     chosen,
                     :active => proc { content_tag :li, :class=>'active' do 
                         content_tag :span, label
                       end },
                     :chosen => proc { content_tag :li, :class=>'chosen' do
                         link_to( label, url )
                       end },
                     :inactive => proc { content_tag :li, link_to( label, url ) }
                     )
  end

  def navigation_link( label, url, active, chosen=nil, title=nil )
    stateful_link_to(
                     active,
                     chosen,
                     :active => proc { content_tag :span, :class=>'active' do 
                         content_tag :span, label
                       end },
                     :chosen => proc { link_to( label, url ) },
                     :inactive => proc { link_to( label, url ) }
                     )
  end

  def current_contact
    @contact
  end

  def icon_tag(icon_name, title=nil)
    image_tag "icons/#{icon_name}.png", :title=>title
  end

  def icon_link(icon_name, path, title=nil)
    link_to icon_tag(icon_name), path, :title=>title
  end

  def new_credit_link( label=nil )
    if current_contact.present?
      icon_link 'add', new_credit_path( :partner_id=>current_contact.partner.id, :title=> "Дать в долг #{current_contact.partner}" )
    else
      icon_link 'add', new_credit_path, "Дать в долг"
    end
  end


  def new_debt_link( label=nil )
    if current_contact.present?
      icon_link 'add', new_debt_path( :partner_id=>current_contact.partner.id, :title=> "Взять в долг у #{current_contact.partner}")
    else
      icon_link 'add', new_debt_path, "Взять в долг"
    end
  end


  def show_flash
    return '' if flash.empty?
    s = content_tag :div, :class => 'flashes' do 
      html = flash.map do |name, msg|
        # next unless name==:error
        content_tag :div, msg.html_safe, :id => "flash_#{name}"
      end
      html.to_s
    end
  end
    
  def show_link(object, content = "Show")
    link_to(content, object) if can?(:read, object)
  end
  
  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object]) if can?(:update, object)
  end
  
  def destroy_link(object, content = "Destroy")
    link_to(content, object, :method => :delete, :confirm => "Are you sure?") if can?(:destroy, object)
  end
  
  def create_link(object, content = "New")
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end


  # Special for Typus
  def admin_session_path
    user_session_path
  end

  def new_admin_session_path
    destroy_user_session_path
    #new_user_session_path
  end

  
  # Ссылка на кредит, кредитору от должника
  # def link_to_show_credit(credit)
  #   url_for :controller => 'users', :action => "token_auth",
  #           :only_path=>false, :auth_token => credit.creditor.authentication_token,
  #           :go => url_for( :controller=>"credits", :action=>"show", :id=>credit.id )
  # end
  
  # Ссылка для подтверждения долга. Посылается должнику заемщиком
  # def link_to_confirm_debt(credit)
  #   url_for :controller => 'users', :action => "token_auth",
  #           :only_path=>false, :auth_token => credit.debtor.authentication_token,
  #           :go => url_for( :controller=>"debts", :action=>"confirm", :id=>credit.id )
  # end



end
