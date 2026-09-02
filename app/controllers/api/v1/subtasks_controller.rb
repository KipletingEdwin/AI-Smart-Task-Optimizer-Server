
module Api
  module V1
    class SubtasksController < ApplicationController
      before_action :set_subtask

      def toggle
        @subtask.update!(completed: !@subtask.completed)
        render json: @subtask
      end

      private

      def set_subtask
        @subtask = Subtask.joins(:task).find_by(id: params[:id], tasks: { user_id: current_user.id })
        render json: { error: "Subtask not found" }, status: :not_found unless @subtask
      end
    end
  end
end