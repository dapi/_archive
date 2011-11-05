module Admin::CompaniesHelper

  def category_column(record)
    link_to(h(record.category.name), :action => :nested, 
                                     :controller => 'categories', 
                                     :id => record.category.id, 
                                     :associations => 'companies')
  end
  
  def category_form_column(record, input_name)
    select :record, :category_id, Category.find(:all).collect{|c| [c.name, c.id]}, {}, { :name => input_name }
  end
  
end