# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def h_lenta_date(day)
    
    "<span class=\"day_number\">#{day.date.day}</span> <span class=\"day_names\">#{I18n.t('date.day_names')[day.date.wday]}</span>"
  end
    
  def link_menu(name, options = {}, html_options = {})
    hclass="menu"
    hclass=hclass+" current" if current_page?(options)
    html_options[:class]=hclass
    link_to name,options,html_options
#    if 
#    end
#    link_to_unless current_page?(options), name, options, html_options, &block
  end
  
  def admin_link_to(name, options={}, html_options = {})
    html_options[:class]='admin'
    link_to name, options, html_options
  end
  
  def display_flash
    if flash[:error]
      %[<div id="flash_message" class="error">#{flash[:error]}</div>]
    elsif flash[:warn]
      %[<div id="flash_message" class="warn">#{flash[:warn]}</div>]
    elsif flash[:notice]
      %[<div id="flash_message" class="notice">#{flash[:notice]}</div>]
    end
  end
  
  def add_error(msg)
    flash[:error] = msg
  end
  
  def add_notice(msg)
    flash[:notice] = msg
  end
  
  def add_message(msg)
    flash[:message] = msg
  end
  
    def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end

  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :class => "flash #{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end  

  
end
