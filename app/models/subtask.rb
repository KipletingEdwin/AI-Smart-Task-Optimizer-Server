
class Subtask < ApplicationRecord
  belongs_to :task

  validates :description, presence: true
  validates :estimated_minutes, numericality: { greater_than: 0 }, allow_nil: true

  default_scope { order(position: :asc) }
end