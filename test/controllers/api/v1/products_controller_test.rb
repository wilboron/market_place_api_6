require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test 'should show product' do
    get api_v1_product_url(@product), as: :json
    assert_response :success

    json_response =  JSON.parse(self.response.body)
    assert_equal @product.title, json_response['title']
  end

  test 'should show products' do
    get api_v1_products_url, as: :json
    assert_response :success
  end

  test 'should create product' do
    assert_difference('Product.count') do
      params = { product: { title: @product.title,
                            price: @product.price,
                            published: @product.published } }
      headers = { Authorization: JsonWebToken.encode(user_id: @product.user_id) }
      post api_v1_products_url, params: params, headers:  headers, as: :json
    end
    assert_response :created
  end

  test 'should forbid create product' do
    assert_no_difference('Product.count') do
      params = { product: { title: @product.title,
                            price: @product.price,
                            published: @product.published } }
      post api_v1_products_url, params: params, as: :json
    end
    assert_response :forbidden
  end

  test 'should update product' do
    patch api_v1_product_url(@product),
          params: { product: { title: @product.title } },
          headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
          as: :json

    assert_response :success
  end

  test 'should forbid update product' do
    patch api_v1_product_url(@product),
          params: { product: { title: @product.title } },
          headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
          as: :json

    assert_response :forbidden
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      headers = { Authorization: JsonWebToken.encode(user_id: @product.user_id) }
      delete api_v1_product_url(@product), headers: headers, as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy product' do
    assert_no_difference('Product.count') do
      headers = { Authorization: JsonWebToken.encode(user_id: users(:two).id) }
      delete api_v1_product_url(@product), headers: headers, as: :json
    end
    assert_response :forbidden
  end
end
