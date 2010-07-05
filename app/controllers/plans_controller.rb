class PlansController < ApplicationController

  def do_record
    @plan = Plan.find(params[:id])
    @plan.record
#    @plan.recorded = true
    @plan.save
#    chorelists.each do |cl|
#       cl.record
#    end 
#    Task.update_next_dates
    redirect_to :action => "index"
  end 

  def input_time_for_week
     @plan = Plan.new
     @plan.duration = Plan.default_duration
     @plan.new_plan_begin_date = (Date.today + 2.days).monday
     @plan.new_plan_end_date = @plan.new_plan_begin_date + 5.days
  end
  
  def make_weekly_foo
    myyr = params[:plan]["new_plan_begin_date(1i)"]
    mymo = params[:plan]["new_plan_begin_date(2i)"]
    myday = params[:plan]["new_plan_begin_date(3i)"]
    begin_date = Date.civil(myyr.to_i,mymo.to_i,myday.to_i)

    myyr = params[:plan]["new_plan_end_date(1i)"]
    mymo = params[:plan]["new_plan_end_date(2i)"]
    myday = params[:plan]["new_plan_end_date(3i)"]
    end_date = Date.civil(myyr.to_i,mymo.to_i,myday.to_i)
print "\n\nBegin Date: ",begin_date.to_s, "\n"
print "End Date: ",end_date.to_s, "\n\n"
    redirect_to( plans_path )
  end 

  def make_weekly
    myduration = params[:plan][:duration]
    
    myyr = params[:plan]["new_plan_begin_date(1i)"]
    mymo = params[:plan]["new_plan_begin_date(2i)"]
    myday = params[:plan]["new_plan_begin_date(3i)"]
    begin_date = Date.civil(myyr.to_i,mymo.to_i,myday.to_i)

    myyr = params[:plan]["new_plan_end_date(1i)"]
    mymo = params[:plan]["new_plan_end_date(2i)"]
    myday = params[:plan]["new_plan_end_date(3i)"]
    end_date = Date.civil(myyr.to_i,mymo.to_i,myday.to_i)

    d = (Date.today + 2.days).monday
    d = begin_date
    new_plans = []

logger.debug "PlansController: here1\n"

#20100315-timing    Task.update_next_dates
logger.debug "PlansController: here2\n"
# Mon-Sat
#    6.times do 
    while d <= end_date
      if Plan.find_all_by_date( d ).empty?
logger.debug "PlansController: here3\n"
        plan = Plan.new({:worker_ids=>Worker.has_chores.collect(&:id)})
        plan.date = d
        plan.duration = myduration #20 # Plan.default_duration

logger.debug "PlansController: here4\n"
print "Plan does not exist for ", d.to_s, "\n"
        Worker.has_chores.each do |w|
          plan.chore_lists.build(:worker_id => w.id )
print "  Creating chores for: ", w.name, "\n"
        end

logger.debug "PlansController: here5\n"
        plan.save
logger.debug "PlansController: here6\n"
        plan.make_assignments
logger.debug "PlansController: here7\n"
#
# mark as recorded so the next one created will assume previous day is complete
# Will unrecord all of the below
#
        plan.recorded = true
        plan.save
        new_plans.push(plan.id)

      else
print "Plan exists for ", d.to_s, "\n"
      end
      d = d.next 

    end

    new_plans.each do |p|
      new_plan = Plan.find(p)
      new_plan.recorded = false
      new_plan.save
    end

#20100315-timing    Task.update_next_dates

    redirect_to( plans_path )

#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @plans }
#    end
  end

  def record_all
#    @plans = Plan.find(:all)
    @plans = Plan.unrecorded
    @plans.each do |p|
      p.record
      p.save
    end
#    Task.update_next_dates
    redirect_to( plans_path )
  end 

  def index_all
    @plans = Plan.by_date

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  def unrecorded_ordered_by_worker
    @plans = Plan.unrecorded.by_date

    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
        send_data PlanDrawer::draw_by_worker( @plans ), :filename => 'plan.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
      format.xml  { render :xml => @plans }
    end
  end 

  def unrecorded_ordered_by_day
    @plans = Plan.unrecorded.by_date

    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
        send_data PlanDrawer::draw_by_date( @plans ), :filename => 'plan.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
      format.xml  { render :xml => @plans }
    end
  end 

  # GET /plans
  # GET /plans.xml
  def index
#    @plans = Plan.find(:all)
    @plans = Plan.recent
    
    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
#        send_data PlanDrawer::draw_by_date( @plans ), :filename => 'plan.pdf', :type => 'application/pdf', :disposition => 'inline'
        send_data PlanDrawer::draw_by_worker( @plans ), :filename => 'plan.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
      format.xml  { render :xml => @plans }
    end
  end

  def printout
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do 
        pdf = PDF::Writer.new
        pdf.text "test"
        send_data pdf.render, :filename => 'plan.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new({:worker_ids=>Worker.has_chores.collect(&:id)})

    @plan.date = Date.today
    @plan.duration = Plan.default_duration

    render :action => "new"
#    if Plan.find_all_by_recorded(false).empty?
#       render :action => "new"
#    else
#       flash[:warning] = 'There are Unrecorded plans.'
#       redirect_to :action => "index"
#    end

#
# Don't know why this doesn't work
#
#    respond_to do |format|
#      if Plan.find_all_by_recorded(false).empty?
#        format.html # new.html.erb
#        format.xml  { render :xml => @plan }
#      else
###        render :action => "do_record"
#        redirect_to(:action => "do_record")
#      end
#    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = Plan.new(params[:plan])

    @plan.workers.each do |w|
print "Adding ", w.name, " to chore_lists\n"
      @plan.chore_lists.build(:worker_id => w.id)
    end 
    @plan.save

    @plan.make_assignments

#    @plan.chore_lists.each do |cl|
#      cl.populate
#    end

    respond_to do |format|
      if @plan.save
        flash[:notice] = 'Plan was successfully created.'
        format.html { redirect_to(@plan) }
        format.xml  { render :xml => @plan, :status => :created, :location => @plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    params[:plan][:worker_ids] ||= []
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        flash[:notice] = 'Plan was successfully updated.'
        format.html { redirect_to(@plan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    Task.update_next_dates

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end

end
