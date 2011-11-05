# -*- coding: utf-8 -*-
module ApplicationHelper
#  include ActsAsTaggable::TagsHelper
  include PhoneHelper
  include Admin::PublicHelper
  
  def tags_link(tags)
    tags.map(&:name) * ','
  end
  
  def render_category_with_all_childs(category, category_func, admin=false, description=false)
    res = "<li>"
    res += category_func.call(category) 
    res += " (#{category.companies_count})"
    res += " " + link_to('Изменить', edit_admin_category_path(category)) if admin
    res += " | " + link_to('Удалить', admin_category_path(category), :confirm => 'Удалить категорию?', :method => :delete) if admin
    res += "<br />" + h(category.description) if description
    if category.children.size > 0
      res += "<ul>"
      category.children.each do |child|
        res += render_category_with_all_childs(child, category_func, admin, description)
      end
      res += "</ul>"
    end
    res += "</li>"
    res
  end
  
  def render_categories_front_end(category, admin=false, description=false)
    render_category_with_all_childs(category, lambda { |category| link_to category.name, category_url(category) }, admin, description)
  end
  
  def yes_no(var)
    var == true ? "да" : "нет"
  end
  

  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
    # Использоваль content_for для замены title страницы?
  end

  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :class => "flash #{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end  

  def breadcrumb objects, delimiter = ' / '
    objects = [objects] unless objects.first.is_a?(Array)

    objects.collect! do |arr|
      last = arr.pop
      arr.collect! do |obj|
        link_to(obj.has_attribute?(:name) ? obj.name : obj.id, obj)
      end
      arr.push last.name
      arr.unshift link_to("Все категории", branches_path)
      arr.join delimiter
    end

    content_tag :div, objects.join('<br />'), :class => "breadcrumb"
  end
  

end
