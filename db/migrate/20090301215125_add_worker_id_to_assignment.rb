class AddWorkerIdToAssignment < ActiveRecord::Migration
  def self.up
     change_table :assignments do |t|
       t.references :worker, :null=>false
     end 
  end

  def self.down
     remove_column :assignments, :worker
  end
end
