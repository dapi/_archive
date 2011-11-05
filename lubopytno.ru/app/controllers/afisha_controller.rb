# -*- coding: utf-8 -*-
class AfishaController < ApplicationController
  layout nil
  
  def index
  end

  def show
  #  render :layout => false
    @number=16
    return render :partial => "common/day"
    
    
    # оставили на потом
    id = params[:id];
    if id=~/-/
      d = Day.find_by_sql ["select * from days where date=?",id];
      @day = d[0];
      else 
      @day =  Day.find(id);
    end
    
    if @day==nil
      raise ActiveRecord::RecordNotFound, "Couldn't find date with ID=#{id}"
    end
    
    
#    @day = Day.find(params[:day]);
    return nil unless @day;
    respond_to do |format|
      format.html # show.html.erb
      format.json { 
        render :json => {  
          :object => "day",
          :success => true,
          :data => @day.to_json
#          { 
#            :day=>,
#            :events=>@day.events.to_json
#          }
        }
      }
    
    end
    
  end

end
