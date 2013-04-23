class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :name
      t.string :protocol
      t.string :forward_ip
      t.integer :forward_port
      t.integer :bind_port
      t.references :project

      t.timestamps
    end
    add_index :proxies, :project_id
  end
end
