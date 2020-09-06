class ApplicationController < ActionController::API
  include Authenticable

  before_action :check_auth

  def check_auth
    current_user
  rescue JWT::JWKError, JWT::DecodeError, JWT::ExpiredSign => e
    render json: { error: "Token: #{e.message}" }, status: :unauthorized
  end
end
