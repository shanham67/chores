class ChoreListsController < ApplicationController
  # GET /chore_lists
  # GET /chore_lists.xml
  def index
    @chore_lists = ChoreList.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chore_lists }
    end
  end

  # GET /chore_lists/1
  # GET /chore_lists/1.xml
  def show
    @chore_list = ChoreList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chore_list }
    end
  end

  # GET /chore_lists/new
  # GET /chore_lists/new.xml
  def new
    @chore_list = ChoreList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chore_list }
    end
  end

  # GET /chore_lists/1/edit
  def edit
    @chore_list = ChoreList.find(params[:id])
  end

  # POST /chore_lists
  # POST /chore_lists.xml
  def create
    @chore_list = ChoreList.new(params[:chore_list])

    respond_to do |format|
      if @chore_list.save
        flash[:notice] = 'ChoreList was successfully created.'
        format.html { redirect_to(@chore_list) }
        format.xml  { render :xml => @chore_list, :status => :created, :location => @chore_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chore_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chore_lists/1
  # PUT /chore_lists/1.xml
  def update
    @chore_list = ChoreList.find(params[:id])

    respond_to do |format|
      if @chore_list.update_attributes(params[:chore_list])
        flash[:notice] = 'ChoreList was successfully updated.'
        format.html { redirect_to(@chore_list) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chore_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chore_lists/1
  # DELETE /chore_lists/1.xml
  def destroy
    @chore_list = ChoreList.find(params[:id])
    @chore_list.destroy

    respond_to do |format|
      format.html { redirect_to(chore_lists_url) }
      format.xml  { head :ok }
    end
  end
end
