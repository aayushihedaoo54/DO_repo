class AddStartedAtToJobs < ActiveRecord::Migration[8.1]
  def change
    add_column :jobs, :started_at, :datetime
  end
end
