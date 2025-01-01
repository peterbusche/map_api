module Api
  class ImagesController < Api::ApplicationController
    before_action :authenticate_api_user, only: [:index, :create]

    def index
      render json: @current_user.images, status: :ok
    end

    def create
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
      image = @current_user.images.build(
        image_path: "/uploads/#{uploaded_file.original_filename}",
        latitude: params[:latitude],
        longitude: params[:longitude]
      )

      if image.save
        render json: { message: 'Image uploaded successfully!', image: image }, status: :created
      else
        render json: { errors: image.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def authenticate_api_user
      @current_user = authenticate_token
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
  end
end
