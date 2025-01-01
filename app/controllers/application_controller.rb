# HOW RUBY TALKS TO MY ANDROID PROJECT
  # 1)Android app sends login credentials to the Ruby backend.
  # 2)Ruby backend validates credentials against the database
  # 3)If valid: Ruby generates a JWT token for the user. The token is sent back to the Android app.
  # 4)The Android app stores the token locally (e.g., SharedPreferences).
  # 5)For subsequent API requests, the Android app sends the token in the Authorization header.
  # 6)The Ruby backend decodes and verifies the token to authenticate the user for each request.




class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # Required for API authentication

  # Common method to identify current user for web and API
  def current_user
    if session[:user_id] # Session-based for web
      @current_user ||= User.find(session[:user_id])
    elsif token_provided? # Token-based for API
      @current_user ||= authenticate_token
    end
  end

  private

  # Check if Authorization header is present
  def token_provided?
    request.headers['Authorization'].present?
  end

  # Decode token and find user
  def authenticate_token
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header
    decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0]
    User.find(decoded['user_id'])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end

