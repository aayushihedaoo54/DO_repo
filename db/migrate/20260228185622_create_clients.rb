class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :client_id
      t.integer :concurrency_limit

      t.timestamps

    end
    add_index :clients, :client_id, unique: true
  end
end
