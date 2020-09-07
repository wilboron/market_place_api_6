class ApplicationController < ActionController::API
  include Authenticable
  before_action :check_auth
end
