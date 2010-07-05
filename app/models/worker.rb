class Worker < ActiveRecord::Base
  has_and_belongs_to_many :plans
  has_and_belongs_to_many :tasks
#  has_many :assignments, :through => :chore_lists
  has_many :assignments

  named_scope :has_chores, :conditions => { :has_chores => true }

  def updated?
     false
  end
end
