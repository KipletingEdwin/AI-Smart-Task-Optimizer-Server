
module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      def index
        tasks = current_user.tasks.includes(:subtasks).order(created_at: :desc)
        render json: tasks.as_json(include: :subtasks)
      end

      def show
        render json: @task.as_json(include: :subtasks)
      end

      def create
        task = current_user.tasks.new(task_params)

        if task.save
          render json: task.as_json(include: :subtasks), status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: @task.as_json(include: :subtasks)
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = current_user.tasks.find_by(id: params[:id])
        render json: { error: "Task not found" }, status: :not_found unless @task
      end

      def task_params
        params.require(:task).permit(:title, :category, :status)
      end
    end
  end
end