require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'should have positive total' do
    order = orders(:one)
    order.total = -1
    assert_not order.valid?
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
end
