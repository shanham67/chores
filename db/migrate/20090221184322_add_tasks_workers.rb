class AddTasksWorkers < ActiveRecord::Migration
  def self.up
    create_table :tasks_workers, :id => false do |t|
      t.references :task, :null=>false
      t.references :worker, :null=>false
    end
  end

  def self.down
    drop_table :tasks_workers
  end
end
