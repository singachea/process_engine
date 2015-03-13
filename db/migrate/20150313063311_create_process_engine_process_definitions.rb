class CreateProcessEngineProcessDefinitions < ActiveRecord::Migration
  def change
    create_table :process_engine_process_definitions do |t|
      t.string :name
      t.string :slug, null: false
      t.string :starting_node
      t.text :description
      t.text :bpmn_xml
      t.jsonb :bpmn_json, default: {}

      t.timestamps null: false
    end
  end
end
