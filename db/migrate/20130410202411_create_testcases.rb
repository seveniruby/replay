class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.string :name
      t.text :data
      t.references :project

      t.timestamps
    end
    add_index :testcases, :project_id
  end
end
