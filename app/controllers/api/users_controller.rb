module Api
  class UsersController < ApplicationController
    before_action :authenticate_api_user, only: [:show]

    def create
      @user = User.new(user_params)
      if @user.save
        render json: { message: "User created successfully!", user: @user }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render json: @current_user, status: :ok
    end

    private

    def authenticate_api_user
      @current_user = authenticate_token
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
end
