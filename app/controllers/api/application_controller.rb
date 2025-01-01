module Api
    class ApplicationController < ActionController::API
      private
  
      def authenticate_token
        auth_header = request.headers['Authorization']
        token = auth_header.split(' ').last if auth_header
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0]
        User.find(decoded['user_id'])
      rescue JWT::DecodeError, JWT::ExpiredSignature
        nil
      end
    end
  end
  