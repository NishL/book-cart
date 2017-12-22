require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "name must not be blank" do
    order = Order.new(name: '')
    assert order.invalid?
  end
end
