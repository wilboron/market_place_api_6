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
    user_payload = {user: { email: @user.email, password: '123456' }}
    patch api_v1_user_url(@user), params: user_payload, as: :json
    assert_response :success
  end

  test 'should not update user when bad params are send' do
    user_payload = {user: { email: 'bad_email', password: '123456' }}
    patch api_v1_user_url(@user), params: user_payload, as: :json
    assert_response :unprocessable_entity
  end

  test 'should not update user when email is taken' do
    other_user = users(:two)
    user_payload = {user: { email: other_user.email, password: '123456' }}
    patch api_v1_user_url(@user), params: user_payload, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :no_content
  end
end
