require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'should have user' do
    order = orders(:one)
    order.user_id = nil
    assert_not order.valid?
  end

  test 'should have valid user' do
    order = orders(:one)
    order.user_id = 2
    assert_not order.valid?
  end

  test 'Should set total' do
    order = Order.new user_id: @order.user_id
    order.products << products(:one)
    order.products << products(:two)
    order.save

    assert_equal (@product1.price + @product2.price), order.total
  end
end
