class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :client_id
      t.integer :priority
      t.string :status
      t.integer :retry_count
      t.datetime :scheduled_at
      t.datetime :completed_at

      t.timestamps

    end
    add_index :jobs , [:client_id,:status]
    add_index :jobs , :scheduled_at
  end
end
