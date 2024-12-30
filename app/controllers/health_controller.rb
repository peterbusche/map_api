class HealthController < ApplicationController
    def ping
        render json: { status: 'success', message: 'Rails server is up and running!' }
    end
end
  
