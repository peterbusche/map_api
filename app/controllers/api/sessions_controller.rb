module Api
  class SessionsController < Api::ApplicationController
    def create
      user = User.find_by(username: params[:username])
      if user&.authenticate(params[:password])
        token = generate_token(user)
        render json: { token: token, user_id: user.id }, status: :ok
      else
        render json: { error: "Invalid username or password" }, status: :unauthorized
      end
    end

    private

    def generate_token(user)
      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
    end
  end
end
