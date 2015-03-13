class CreateProcessEngineProcessInstances < ActiveRecord::Migration
  def change
    create_table :process_engine_process_instances do |t|
      t.integer :status, default: 0
      t.string :states, array: true, default: []
      t.string :creator
      t.references :process_definition, index: true

      t.timestamps null: false
    end
    add_index :process_engine_process_instances, :states, using: :gin
    add_index :process_engine_process_instances, :creator
    add_foreign_key :process_engine_process_instances, :process_engine_process_definitions, column: :process_definition_id
  end
end
