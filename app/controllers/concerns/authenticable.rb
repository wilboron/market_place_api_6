module Authenticable
  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)

    @current_user = User.find_by_id(decoded[:user_id])
  end

  def check_auth
    current_user
  rescue JWT::JWKError, JWT::DecodeError, JWT::ExpiredSign
    head(:unauthorized)
  end

  def check_login
    current_user || head(:forbidden)
  end
end
