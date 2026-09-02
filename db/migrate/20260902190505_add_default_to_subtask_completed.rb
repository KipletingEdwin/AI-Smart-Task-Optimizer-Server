

class AddDefaultToSubtaskCompleted < ActiveRecord::Migration[8.1]
  def up
    change_column_default :subtasks, :completed, from: nil, to: false
    Subtask.where(completed: nil).update_all(completed: false)
  end

  def down
    change_column_default :subtasks, :completed, from: false, to: nil
  end
end