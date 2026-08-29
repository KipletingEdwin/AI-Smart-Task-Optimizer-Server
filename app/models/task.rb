
class Task < ApplicationRecord
  belongs_to :user
  has_many :subtasks, dependent: :destroy

  validates :title, presence: true

  enum :status, { pending: "pending", in_progress: "in_progress", completed: "completed" }, default: "pending"
end