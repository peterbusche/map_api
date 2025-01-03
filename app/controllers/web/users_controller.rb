module Web
    class UsersController < ApplicationController
      def index
        @users = User.all
      end
  
      def show
        @user = User.find(params[:id])
      end
  
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to web_user_path(@user), notice: "User created successfully!"
        else
          render :new, status: :unprocessable_entity
        end
      end
  
      private
  
      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
    end
  end
  