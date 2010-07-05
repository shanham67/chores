class Task < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :assignments

  named_scope :past_due, lambda { |*args| { :conditions => ["next_date < ?", args.first || Date.today] } }
  named_scope :by_next_date_desc, :order => 'next_date DESC'
  named_scope :by_next_date, :order => 'next_date, duration DESC, recurrance ASC'
  named_scope :for_every_plan, :conditions => { :recurrance => 0 }
  named_scope :by_priority, :order => 'priority DESC'
  named_scope :by_description, :order => 'description'
  named_scope :by_priority_then_date_then_description, :order => 'priority DESC, next_date DESC, description'

  def update_next_date
    unless assignments.empty?
    self.set_dates( assignments.complete.by_date_complete.last.date_complete ) 
    end
  end

  def set_dates( thedate )
     self.last_date = thedate
     self.next_date = thedate + self.recurrance.days 
#     save
  end

  def occurances_per_year
     if recurrance == 0 
       300
     else
       300/recurrance
     end
  end

  def annual_time_requirement
     duration * occurances_per_year
  end

  def annotated_description
    if recurrance == 0 
      "* " + description
    else
      description
    end
  end 

  def self.total_time_requirement
     tasks = self.find(:all)
     the_total = 0
     for task in tasks
       the_total += task.annual_time_requirement  
     end
     the_total
  end 

  def self.reset_all
    @tasks = self.find(:all)
    for task in @tasks
      task.last_date = "2000-01-01"
      task.next_date = task.last_date + task.recurrance.days
      task.save
    end 
  end 

  def self.test_call_task
     @tasks = self.find(:all).collect(&:description)
  end 

  def self.update_next_dates
    Task.all.each do |task|
#      latest_date = Date.parse("2000-01-01")
#      task.assignments.each do |a|
#        if a.chore_list.plan.recorded
#          if a.chore_list.plan.date > latest_date
#            latest_date = a.chore_list.plan.date
#          end
#        end
#      end
#      task.last_date = latest_date
#      task.next_date = latest_date + task.recurrance.days
      task.update_next_date
      task.save
    end 
  end 

  def self.update_next_dates_old
    reset_all

    for plan in Plan.recorded.by_date
      plan.chore_lists.each do |cl|
        cl.assignments.each do |a|
          a.task.last_date = a.date_complete
          a.task.next_date = a.date_complete + a.task.recurrance.days
          a.task.save
        end
      end
    end
  end
          
end
