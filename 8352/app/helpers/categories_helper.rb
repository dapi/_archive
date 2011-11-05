# -*- coding: utf-8 -*-
module CategoriesHelper
  
  extend ActiveSupport::Memoizable
  
  def category_tree(roots)
    result = '<div id="aac_sortable_tree_response">'
    
    result += "<ul class='tree_root'>"
    

    roots.each { |root| result += _tree_category(root) }
    result += '</ul>'
    result += '</div'
  end
  
  #memoize :category_tree
  
  def _tree_category(category)
    anchor = "aac_tree_#{category.id.to_s}"
    
    result = tag('a', {:name => anchor}) + tag('/a')
    result += "<li>"
    result += '<b>' if @category == category.id

    result += link_to h(category.name),category_path(category)

    if category.children_count > 0 then
      result += '&nbsp;'
      result += content_tag('a', '[*]', :onclick => "new Element.toggle('#{anchor}'); return false",  :href => "\##{anchor}")
    end
    result += '</b>' if @category == category.id
    result += '</li>'

    
    if category.children_count > 0
      #      addon = (category.parents_count == 0 or category.children_ids.include?(@category) or (category.self_and_siblings_ids.include?(@category) and category.children_count == 0)) ? '' : ' style="display: none;"'
      addon=''
      # id='#{anchor}'
      result += "<ul  id='#{anchor}' #{addon}>"
      category.children.each { |child| result += _tree_category(child) }
      result += '</ul>'
      result += sortable_element("#{anchor}", :update => 'aac_sortable_tree_response', :url => "ajaxurl")      
    end
    result
  end
  
  private :_tree_category

end
