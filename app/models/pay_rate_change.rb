class PayRateChange < ActiveRecord::Base
  belongs_to :worker
  validates_numericality_of :new_rate, :greater_than_or_equal_to => 0, :message => "value must be >= 0", :on => :update
end
