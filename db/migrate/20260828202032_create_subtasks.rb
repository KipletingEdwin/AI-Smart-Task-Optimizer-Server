
class CreateSubtasks < ActiveRecord::Migration[8.1]
  def change
    create_table :subtasks do |t|
      t.string :description
      t.integer :estimated_minutes
      t.integer :position
      t.boolean :completed
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
