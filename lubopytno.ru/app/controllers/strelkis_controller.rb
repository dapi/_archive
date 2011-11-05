class StrelkisController < ApplicationController
  # GET /strelkis
  # GET /strelkis.xml
  def index
    @strelkis = Strelki.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @strelkis }
    end
  end

  # GET /strelkis/1
  # GET /strelkis/1.xml
  def show
    @strelki = Strelki.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @strelki }
    end
  end

  # GET /strelkis/new
  # GET /strelkis/new.xml
  def new
    @strelki = Strelki.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @strelki }
    end
  end

  # GET /strelkis/1/edit
  def edit
    @strelki = Strelki.find(params[:id])
  end

  # POST /strelkis
  # POST /strelkis.xml
  def create
    @strelki = Strelki.new(params[:strelki])

    respond_to do |format|
      if @strelki.save
        flash[:notice] = 'Strelki was successfully created.'
        format.html { redirect_to(@strelki) }
        format.xml  { render :xml => @strelki, :status => :created, :location => @strelki }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @strelki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /strelkis/1
  # PUT /strelkis/1.xml
  def update
    @strelki = Strelki.find(params[:id])

    respond_to do |format|
      if @strelki.update_attributes(params[:strelki])
        flash[:notice] = 'Strelki was successfully updated.'
        format.html { redirect_to(@strelki) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @strelki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /strelkis/1
  # DELETE /strelkis/1.xml
  def destroy
    @strelki = Strelki.find(params[:id])
    @strelki.destroy

    respond_to do |format|
      format.html { redirect_to(strelkis_url) }
      format.xml  { head :ok }
    end
  end
end
