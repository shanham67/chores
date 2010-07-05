class CreatePlansWorkers < ActiveRecord::Migration
  def self.up
    create_table :plans_workers, :id => false do |t|
      t.references :plan, :null=>false
      t.references :worker, :null=>false
    end
  end

  def self.down
     drop_table :plans_workers
  end
end
