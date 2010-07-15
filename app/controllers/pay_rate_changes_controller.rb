class PayRateChangesController < ApplicationController

  before_filter :get_worker

  # GET /pay_rate_changes
  # GET /pay_rate_changes.xml
  def index
#    @pay_rate_changes = PayRateChange.all
    @pay_rate_changes = @worker.pay_rate_changes

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pay_rate_changes }
    end
  end

  # GET /pay_rate_changes/1
  # GET /pay_rate_changes/1.xml
  def show
#    @pay_rate_change = PayRateChange.find(params[:id])
    @pay_rate_change = @worker.pay_rate_changes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pay_rate_change }
    end
  end

  # GET /pay_rate_changes/new
  # GET /pay_rate_changes/new.xml
  def new
#    @pay_rate_change = PayRateChange.new
    @pay_rate_change = @worker.pay_rate_changes.build
    @pay_rate_change.effective_date = Date::today

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pay_rate_change }
    end
  end

  # GET /pay_rate_changes/1/edit
  def edit
#    @pay_rate_change = PayRateChange.find(params[:id])
    @pay_rate_change = @worker.pay_rate_changes.find(params[:id])
  end

  # POST /pay_rate_changes
  # POST /pay_rate_changes.xml
  def create
#    @pay_rate_change = PayRateChange.new(params[:pay_rate_change])
    @pay_rate_change = @worker.pay_rate_changes.build(params[:pay_rate_change])

    respond_to do |format|
      if @pay_rate_change.save
#        format.html { redirect_to(@pay_rate_change, :notice => 'PayRateChange was successfully created.') }
        format.html { redirect_to([@worker, @pay_rate_change], :notice => 'PayRateChange was successfully created.') }
        format.xml  { render :xml => @pay_rate_change, :status => :created, :location => @pay_rate_change }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pay_rate_change.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pay_rate_changes/1
  # PUT /pay_rate_changes/1.xml
  def update
#    @pay_rate_change = PayRateChange.find(params[:id])
    @pay_rate_change = @worker.pay_rate_changes.find(params[:id])

    respond_to do |format|
      if @pay_rate_change.update_attributes(params[:pay_rate_change])
#        format.html { redirect_to(@pay_rate_change, :notice => 'PayRateChange was successfully updated.') }
        format.html { redirect_to([@worker,@pay_rate_change], :notice => 'PayRateChange was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pay_rate_change.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_rate_changes/1
  # DELETE /pay_rate_changes/1.xml
  def destroy
#    @pay_rate_change = PayRateChange.find(params[:id])
    @pay_rate_change = @worker.pay_rate_changes.find(params[:id])
    @pay_rate_change.destroy

    respond_to do |format|
#      format.html { redirect_to(pay_rate_changes_url) }
      format.html { redirect_to(worker_pay_rate_changes_path(@worker)) }
      format.xml  { head :ok }
    end
  end
private
  def get_worker
    @worker = Worker.find(params[:worker_id])
  end
end
