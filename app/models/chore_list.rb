class ChoreList < ActiveRecord::Base
  belongs_to :plan
  belongs_to :worker
  has_many :assignments, :dependent => :destroy

  def assignment_attributes=(assignment_attributes)
    assignment_attributes.each do |attributes|
       a = assignments.find(attributes[0])
       a.update_attributes(attributes[1])
    end
  end
    
  def unrecord
    assignments.each do |a|
      a.unrecord
    end
    save
  end

  def record
    assignments.each do |a|
      a.record
print "recording: ", a.id, "\n"
    end
    save
  end 

  def add_assignment( tid )
    @task = Task.find(tid)
    assignments.build( :task_id => @task.id, :worker_id => self.worker.id, :complete => false )
    self.duration = self.duration + @task.duration
  end

  def recalc_duration
    self.duration = 0
    assignments.each do |a|
      self.duration += a.task.duration
    end 
  end

  def populate
    self.duration = 0
    for t in self.worker.tasks do 
      assignments.build( :task_id => t.id, :complete => false )
      self.duration = self.duration + t.duration
    end 
    save
  end 
end
