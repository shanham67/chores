class Worker < ActiveRecord::Base
  has_and_belongs_to_many :plans
  has_and_belongs_to_many :tasks
#  has_many :assignments, :through => :chore_lists
  has_many :assignments
  has_many :pay_rate_changes
  validates_numericality_of :hourly_rate, :greater_than_or_equal_to => 0, :message => "value must be >= 0", :on => :update

  named_scope :has_chores, :conditions => { :has_chores => true }

  def updated?
     false
  end
end
