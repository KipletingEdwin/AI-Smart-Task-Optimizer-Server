
module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        skip_before_action :authenticate_request

        def create
          user = User.find_by(email: params[:email])

          if user&.authenticate(params[:password])
            token = JsonWebToken.encode({ user_id: user.id })
            render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
          else
            render json: { error: "Invalid email or password" }, status: :unauthorized
          end
        end
      end
    end
  end
end