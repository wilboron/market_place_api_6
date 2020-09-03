require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should show user' do
    get api_v1_user_url(@user), as: :json
    assert_response :success
    # Test to ensure response contains the correct email
    json_response = JSON.parse(self.response.body)
    assert_equal @user.email, json_response['email']
  end

  test 'should create user' do
    assert_difference('User.count') do
      user_payload = { user: { email: 'test@test.org', password: '123456' } }
      post api_v1_users_url, params: user_payload, as: :json
    end
    assert_response :created
  end

  test 'should not create user with taken email' do
    assert_no_difference('User.count') do
      user_payload = { user: { email: @user.email, password: '123456' } }
      post api_v1_users_url, params: user_payload, as: :json
    end
    assert_response :unprocessable_entity
  end
end
