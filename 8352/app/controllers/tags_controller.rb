# -*- coding: utf-8 -*-
class TagsController < ApplicationController

  access_control do
     allow all
  end

  def index
    @tags = Company.tag_counts().sort { |a,b| a.name <=> b.name } #:conditions => {:pending => false}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end
  
  def show
    @names = params[:id].split(',')
    
    @tags = @names.map { |name| Tag.find_by_name(name) }
    
    @companies=Company.find_tagged_with(params[:id],:match_all=>true)
    
    
    # Все теги выбранных элементов помимо указанных тэгов
    
    @n=[]
      
    @companies.map { |c| @n = @n + c.tag_list }
    
    @nested_tags=@n.compact.uniq.reject { |n| 
      res=false
      @names.each { |a|
        res=true if a==n
      }
      res
    }.map { |n| Tag.find_by_name(n) } || []

#    @nested_tags=[]
    # unless @nested_tags
    
#    @nested_tags=Tag.find_nested_tags(@tags,Company).sort { |a,b| a.name<=>b.name }
    
    
#        .reject{|t| t.taggable_type!='RestultCategory'}.map(&:taggable).compact.uniq
 #   @tags.map
    
    #    res=ResultCategory.find_tagged_with(params[:id],:match_all=>true)
#    @taggings=Tagging.find(:all, :conditions=>{:tag_id=>@tags.map { |t| t.id}})
    
#    @taggables=@taggings.map(&:tag).uniq.delete(@tags) || []
    
#    @taggables=@taggings.map(&:tag).uniq.delete(@tags) || []
    
#    @taggables=
 #   @nested_tags=@taggings.map(&:tag).uniq.delete(@tags) || []
    
#    @tag = Tag.find_by_name(params[:id])
    
#    @companies = @tag.taggings.map(&:taggable).compact.uniq
#    @companies = @tag.taggings.reject{|t| t.taggable_type!='Company'}.map(&:taggable).compact.uniq
#    @cats = @tag.taggings.reject{|t| t.taggable_type!='RestultCategory'}.map(&:taggable).compact.uniq
#    @cats = @tag.taggings.map(&:taggable).compact.uniq
    
#    @nested_tags = []
#     @tag.taggings.map(&:taggable).each { |t| @nested_tags=@nested_tags+t.tags }
    
#     @nested_tags.compact.uniq.delete(@tag).sort { |x,y| x.name<=>y.name }
    
#    @companies = @companies.paginate :page => params[:page], :per_page => configatron.companies_per_page
    
    respond_to do |format|
      format.html # show.html.erb
   #   format.xml  { render :xml => @tag }
    end
  end

  
end

class TagsBackup
  # GET /tags
  # GET /tags.xml

  # GET /tags/1
  # GET /tags/1.xml

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to(@tag) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
end
