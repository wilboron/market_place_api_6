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
    assert_difference('User.count', 1) do
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

  test 'should update user' do
    params = {user: { email: @user.email}}
    headers = { Authorization: JsonWebToken.encode(user_id: @user.id)}
    patch api_v1_user_url(@user), params: params, headers: headers, as: :json
    assert_response :success
  end

  test 'should forbid update user' do
    params = {user: { email: @user.email}}
    patch api_v1_user_url(@user), params: params, as: :json
    assert_response :forbidden
  end

  test 'should not update user when bad params are send' do
    params = {user: { email: 'bad_email'}}
    headers = { Authorization: JsonWebToken.encode(user_id: @user.id)}
    patch api_v1_user_url(@user), params: params, headers: headers, as: :json
    assert_response :unprocessable_entity
  end

  test 'should not update user when email is taken' do
    other_user = users(:two)
    params = {user: { email: other_user.email}}
    headers = { Authorization: JsonWebToken.encode(user_id: @user.id)}
    patch api_v1_user_url(@user), params: params, headers: headers, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      headers = { Authorization: JsonWebToken.encode(user_id: @user.id)}
      delete api_v1_user_url(@user), headers: headers, as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy user' do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), headers: headers, as: :json
    end
    assert_response :forbidden
  end
end
