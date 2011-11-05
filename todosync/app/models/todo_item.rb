# -*- coding: utf-8 -*-
class TodoItem < ActiveRecord::Base
#  require 'composite_primary_keys'
#  set_primary_keys :remote_application_id, :item_id

  belongs_to :remote_application
  
  validates_presence_of :text #, :remote_applicaion_id
  
  before_create :define_composed_id
  
  def define_composed_id
    self.remote_application_id=
      RemoteApplication.find_by_application_uid('web').id# if self.remote_application_id.blank?
    
    # TOFIX узкое место, надо или лочить базу или заводить инкрементор
    self.remote_application.increment!(:last_item_id)
    self.item_id=self.remote_application.last_item_id
  end
  
  def self.imoport
    raise "import is not implemented"
  end
  
  def self.export(sync_point=nil)
    if sync_point.blank?
      last_timestamp=nil
      todoitems = TodoItem.all.map { |t| 
        last_timestamp=t.updated_at if last_timestamp.blank? or t.updated_at>last_timestamp
        {
          :text=>t.text,
          :timestamp=>t.updated_at,
          :is_removed=>t.is_removed,
          :application_id=>t.remote_application_id,
          :item_id=>t.item_id,
          :pos=>t.position
        } 
      }
      return { 
        :last_timestamp=>last_timestamp,
        :todoitems=>todoitems
      }
    else
      raise "export sync_point is not implemented"
    end
  end
  
  
#   def destroy
#     self.update_attribute(:is_removed,true)
#     self.save
#   end
end
