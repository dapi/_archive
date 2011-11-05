class Source < ActiveRecord::Base

  self.establish_connection :grabber
  
  has_many :results

  has_many :ad_results

#  has_many :companies, :through => :results
#  has_many :result_categories
  has_many :results_to_company_groups

  
#  has_many :jobs

  after_create :update_from_grabber_module
  
  def update_from_grabber_module
    require "Grabber::#{self.grabber_module}".underscore
    grabber = "Grabber::#{self.grabber_module}".constantize.new
    self.update_attributes :target_url => grabber.target_url,
                           :description => grabber.target_description
  end
  
  def results_updated_count # для typus
    results.updated.count
  end
  
  def results_importable_count # для typus
    results.importable(self.id).count
  end
  
  def results_imported_count # для typus
    results.imported(self.id).count
  end
  
  def results_noimportable_count # для typus
    Result.find_by_sql(["select * from results where state='updated' and results.source_id=? and category_name is not null and category_name not in (select category_name from results_to_company_groups where source_id=?)",
                        self.id,self.id]).count
  end
  
  def unprocessed_categories_count
    unprocessed_categories.count
  end

  def set_company_groups(cats)

    cats.each_value do |cat|
            
      if cat[:id].blank? || cat[:id]==""
        # ничего не устанавливаем
      elsif cat[:id].to_i>0
        ResultsToCompanyGroup.create!(:company_group_id=>cat[:id],
                                      :category_name=>cat[:title],
                                      :source_id=>self.id)
        
      else
        raise "Error! Bad category id selected: #{cat[:id]}"
      end
    end
  end
  

  def import_results

    #   logger = Logger.new("#{RAILS_ROOT}/log/importer.log")
      
    results = Result.importable(self.id)
    
    updated_companies_count=0
    new_companies_count=0
    
    results.andand.each { |res| 
      p "result is #{res.id}, #{res.name}"
      res.import
      if res.fine? 
        new_companies_count+=1
      elsif res.partly?
        updated_companies_count+=1
      end
    }
    
    {:updated=>updated_companies_count,
      :new=>new_companies_count,
      :all=>new_companies_count+updated_companies_count
    }
  end
  
  def unprocessed_categories
    Result.find_by_sql(["select results.category_name, count(*) as count from results  where state='updated' and results.source_id=? and category_name is not null and category_name not in (select category_name from results_to_company_groups where source_id=?) group by results.category_name",
                        self.id, self.id]).
      sort { |x,y| x.category_name<=>y.category_name }
  end


end

