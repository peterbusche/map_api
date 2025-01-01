module Web
    class SessionsController < ApplicationController
      def new
      end
  
      def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
          session[:user_id] = user.id
          redirect_to web_user_path(user), notice: "Logged in successfully!"
        else
          flash.now[:alert] = "Invalid username or password"
          render :new, status: :unprocessable_entity
        end
      end
  
      def destroy
        session[:user_id] = nil
        redirect_to web_root_path, notice: "Logged out!"
      end
    end
  end
  