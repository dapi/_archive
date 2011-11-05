# -*- coding: utf-8 -*-
class IphoneController < ApplicationController
  
  def index
    init
  end
  
  def init
    # params[:version] дают, но мы не смотрим
    
    @remote_application = RemoteApplication.new(:name=>params[:application_name],
                                                :application_uid=>params[:application_uid])
    
    if @remote_application.save ||
        @remote_application=RemoteApplication.
        find_by_application_uid(params[:application_uid])
      init_result
    else
      respond_to do |format|
        format.html { render :xml=>@remote_application.errors, :status => :unprocessable_entity }
        format.json { render :json=>@remote_application.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def init_result
            @result = [:application_id=>@remote_application.id,
                       :application_token=>@remote_application.token,
                       :created_at=>@remote_application.created_at,
                       :server_version=>'dev 0.1',
                       :sync=>TodoItem.export()]
    respond_to do |format|
        format.html { render :xml=>@result, :status => :created }
        format.json { render :json=>@result, :status => :created }
    end
  end
  
  private :init_result
  
  def sync
    @app = RemoteApplication.find_by_token(params[:application_token])
    if @app
      if params[:sync]

        # sync= хэш:
        #last_timestamp = последний timestamp в базе (хотя его можно вычислить и из выдаваемого списка)
        #todoitems = массив записей, как есть, order by position с момента последнего обновления.
        sync=ActiveResource::Formats::JsonFormat::decode(params[:sync])
        TodoItem.import(sync.todoitems,sync.last_timestamp)
        @sync=TodoItem.export(sync.last_timestamp)
      else 
        @sync=TodoItem.export()
      end
      
      respond_to do |format|
        format.html { render :xml=>[:sync=>@sync] }
        format.json { render :json=>[:sync=>@sync] }
      end

      
    else
      respond_to do |format|
        format.html { render :xml=>"no application with such token", :status => :unauthorized }
        format.json { render :json=>"no application with such token", :status => :unauthorized }
      end
    end
    

  end
end
