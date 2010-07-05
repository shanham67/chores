class Assignment < ActiveRecord::Base
  belongs_to :chore_list
  belongs_to :task
  belongs_to :worker

  named_scope :by_date_complete, :order => 'date_complete ASC'
  named_scope :complete, :conditions => { :complete => true } 
  named_scope :incomplete, :conditions => { :complete => false } do
    def mark_completed
      each { |i| i.update_attribute(:complete, true)}
    end
  end

  def unrecord
    self.date_complete = "2000-1-1"
    self.complete = false
    save
#
# Did save before updating task dates since it will look through
# all of the assignments to determine the preview completion date
#
    task.update_next_date
  end

  def record
    self.date_complete = chore_list.plan.date
    if date_complete > task.last_date 
      task.set_dates( date_complete )
      task.save
    end
    self.complete = true
    save
  end

  def date_complete_foo
    if chore_list.plan.recorded?
      chore_list.plan.date
    else
      Date.parse("1/1/2000")
    end
  end 

  def self.assign_workers
    @assignments = self.find(:all)
    @assignments.each do |a|
      a.worker_id = a.chore_list.worker_id
      a.save
    end
  end

  def self.update_date_complete_for_all
    @assignments = self.find(:all)
    @assignments.each do |a|
      if a.chore_list.plan.recorded?
        a.date_complete = a.chore_list.plan.date
        a.complete = true
        a.save
      end 
    end
  end 

end
