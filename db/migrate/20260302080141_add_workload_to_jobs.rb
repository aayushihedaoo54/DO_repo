class AddWorkloadToJobs < ActiveRecord::Migration[8.1]
  def change
    add_column :jobs, :workload, :string
  end
end
