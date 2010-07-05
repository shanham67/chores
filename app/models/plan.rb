class Plan < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :chore_lists, :dependent => :destroy
  attr_accessor :new_plan_begin_date
  attr_accessor :new_plan_end_date

  named_scope :recent, lambda { { :conditions => ['date > ?', 2.weeks.ago], :order => 'date' } }
  named_scope :by_date, :order => 'date'
  named_scope :recorded, :conditions => { :recorded => true }
  named_scope :unrecorded, :conditions => { :recorded => false }

  def record
     chore_lists.each do |cl|
       cl.record
     end
     self.recorded = true
  end

  def plan_logger( txt )
    logger.debug "Plan::" + txt
  end

  def self.default_duration
     30    
  end 
  
  def human_date
    date.strftime("%A, %b %d")
  end

  def make_assignments

    chore_lists.each do |cl|
      cl.recalc_duration
      cl.save
    end

    tasks = Task.past_due( self.date ).by_priority_then_date_then_description

    tasks.each do |t|

      worker_found = false
      latest_date = "2000-1-1".to_date
      @assign_to = nil
#
# for each of the workers which 'can' do this task...
#
      t.workers.each do |w|

        cl = chore_lists.find_by_worker_id(w)
 
#if there is no chore list for this worker then the worker is not
#included in this plan
        unless cl.nil?
       
          if (cl.duration + t.duration) <= self.duration

            @a = t.assignments.complete.by_date_complete.find_all_by_worker_id( w.id ).last
           
#if nil then we haven't assigned this task to this worker yet.  If there is time to
#do it then assign it to this one
            if @a.nil?
              @assign_to = w
              break
            else
              if @a.date_complete > latest_date 
                latest_date = @a.date_complete
                @assign_to = w
              end
            end 
          end
        end
      end

      if @assign_to.nil?
        plan_logger "NO WORKER FOUND FOR: " + t.description 
      else
        cl = chore_lists.find_by_worker_id(@assign_to.id)
        cl.add_assignment(t)
        cl.save
#
# This line keeps this task from showing on the second or third day when a batch of plans
# are being created since the Task.past_due looks at 'next_date' when is set by 'set_dates'
#
        t.set_dates( self.date )
        t.save
      end

    end

  end #make_assignments

  def make_assignments_old

    chore_lists.each do |cl|
      plan_logger "recalcing duration for " + cl.id.to_s 
      cl.recalc_duration
      cl.save
    end

#    Task.update_next_dates

plan_logger "Calling Task.past_due...\n"

#    tasks = Task.past_due( self.date ).by_priority.by_next_date
    tasks = Task.past_due( self.date ).by_priority_then_date_then_description

    tasks.each do |t|

      worker_found = false
      plan_logger t.next_date.to_s + "-" + t.description 

      t.workers.each do |w|

# compare the workers for this task to the workers included in this plan
        if workers.exists?(w)
 
            plan_logger "Checking " + w.name 
          if w.assignments.find_all_by_task_id(t).empty?
            plan_logger t.description + " has never been assigned\n"
            chore_lists.find_all_by_worker_id( w.id ).each do |cl|
                  plan_logger "checking " + w.name + " from plan.chore_list\n"
              if (cl.duration + t.duration) <= self.duration 
                @assign_to = w
                  plan_logger "Select " + w.name + " because never has been assigned " + t.description 
                worker_found = true
                break
              end
            end
          end

        else
          plan_logger "*** " + w.name + " can do '" + t.description + "' but not included in plan\n" 
        end

        if worker_found 
          break
        end

      end

      unless worker_found

        latest_date = Date.today + 10.years

        t.workers.each do |w|
          plan_logger "BY_DATE(" + w.name 
          unless t.assignments.find_all_by_worker_id(w).empty?
            a = t.assignments.find_all_by_worker_id(w).sort_by(&:date_complete).last
            plan_logger "a.date_complete: " + a.date_complete.to_s
            plan_logger "latest_date: " + latest_date.to_s
            if a.date_complete <= latest_date 
              plan_logger "latest_date: ok"
              if workers.exists?(w)
                plan_logger "worker.exists?(w)=true"
#               plan_logger "cl.duration: " + chore_lists.find_by_worker_id(w).duration.to_s
                if (chore_lists.find_by_worker_id(w).duration + t.duration) <= self.duration
                  @assign_to = w
                  plan_logger "Select " + a.worker.name + " for " + t.description + " because it is their turn.\n"
                  latest_date = a.date_complete
                  worker_found = true
                end 
              end
            end
          end
        end

      end

      if worker_found
            plan_logger "WORKER(" + @assign_to.name + ") FOUND FOR: " + t.description 
        chore_lists.find_all_by_worker_id(@assign_to.id).each do |cl|
            plan_logger "Assigning " + t.description + " to " + @assign_to.name 
            plan_logger "Task.duration " + t.duration.to_s 
            plan_logger "BEFORE: " + cl.duration.to_s 
          cl.add_assignment(t)
            plan_logger "AFTER: " + cl.duration.to_s 
          cl.save
          t.set_dates( self.date )
          t.save
          break
        end
      else
            plan_logger "NO WORKER FOUND FOR: " + t.description 
      end

    end

  end #make_assignments

  def test_assignments
     workers.build(:worker_id=>1)
     workers.build(:worker_id=>2)
     workers.build(:worker_id=>3)
     workers.build(:worker_id=>4)
     chore_lists.build(:worker_id=>1)
     chore_lists.build(:worker_id=>2)
     chore_lists.build(:worker_id=>3)
     chore_lists.build(:worker_id=>4)
     latest_date = Date.today
     t = Task.find(110)
     t.workers.each do |w|
       a = t.assignments.find_all_by_worker_id(cl.worker).sort_by(&:date_complete).last
print "worker: " + w.id.to_s + "\n"
print "date_complete: " + a.date_complete.to_s + "\n"
print "latest_date: " + latest_date.to_s + "\n"
       if a.date_complete < latest_date
print "choosing: " + cl.worker.id.to_s + "\n"
         latest_date = a.date_complete
       else
print "not choosing: " + w.id.to_s + "\n"
       end
     end 
  end

end
