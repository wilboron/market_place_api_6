require 'test_helper'

class Api::V1::TokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end
  test 'should get JWT token' do
    user_params = { user: { email: @user.email, password: 'g00d_pa$$' } }
    post api_v1_tokens_url, params: user_params, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_not_nil json_response['token']
  end

  test 'should not get JWT token when password is wrong' do
    user_params = { user: { email: @user.email, password: 'b@d_pa$$' } }
    post api_v1_tokens_url, params: user_params, as: :json
    assert_response :unauthorized
  end

  test 'should not get JWT token when email is invalid' do
    user_params = { user: { email: 'bad_email', password: 'b@d_pa$$' } }
    post api_v1_tokens_url, params: user_params, as: :json
    assert_response :unauthorized
  end

end
