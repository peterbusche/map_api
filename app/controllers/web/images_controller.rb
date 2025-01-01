module Web
    class ImagesController < ApplicationController
      before_action :require_login, only: [:new, :create]
  
      def new
        @user = User.find(params[:user_id])
        @image = Image.new
      end
  
      def create
        @user = User.find(params[:user_id])
        uploaded_file = params[:image][:image_path]
        uploads_dir = Rails.root.join("public", "uploads")
  
        # Ensure the uploads directory exists
        FileUtils.mkdir_p(uploads_dir)
  
        file_path = uploads_dir.join(uploaded_file.original_filename)
  
        # Save the file to the server
        File.open(file_path, "wb") do |file|
          file.write(uploaded_file.read)
        end
  
        # Save the file path and metadata to the database
        @image = @user.images.build(
          image_path: "/uploads/#{uploaded_file.original_filename}",
          latitude: params[:image][:latitude],
          longitude: params[:image][:longitude]
        )
  
        if @image.save
          redirect_to web_user_path(@user), notice: "Image uploaded successfully!"
        else
          render :new, status: :unprocessable_entity
        end
      end
  
      private
  
      def image_params
        params.require(:image).permit(:image_path, :latitude, :longitude)
      end
  
      def require_login
        unless session[:user_id]
          redirect_to web_login_path, alert: "You must be logged in to upload images."
        end
      end
    end
  end
  