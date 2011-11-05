# -*- coding: utf-8 -*-
class HomeController < ApplicationController
    
  #before_filter :authenticate  
  
  def index
    @place_types=PlaceType.find(:all)
    
    list = ['2009-07','2009-08','2009-09','2009-10','2009-11']

    @lenta={ }
    
    list.each { |m| 
      month = Month.find(m)
      key = "#{month.year}-#{month.en_month_name}"
      @lenta[key.downcase]=
      {
        :year=>month.year,
        :num=>month.month,
        :length=>month.days_in_month,
        :link=>month.link,
        :html=>render_to_string(:partial => 'lenta/month', :locals => {:month=>month})
      }
    }
    
  end
  
  def about
  end
  
  def reklama
  end
  
end
