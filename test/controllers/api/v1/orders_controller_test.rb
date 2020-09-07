require 'test_helper'

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test 'should forbid orders for unlogged' do
    get api_v1_orders_url, as: :json
    assert_response :forbidden
  end

  test 'should show orders' do
    get api_v1_orders_url,
        headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
        as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal @order.user.orders.count, json_response['data'].count
  end

  test 'should show order' do
    get api_v1_order_url(@order),
        headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
        as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)
    title = json_response.dig(:included, 0, :attributes, :title)
    assert_equal @order.products.first.title, title
  end
end
