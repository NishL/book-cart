require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Test cart adds unique products.
  test "add unique products to the cart" do
    cart = Cart.new                         # Create a cart.
    cart.add_product(products(:one)).save!  # Add product one from the products fixture to the cart.
    cart.add_product(products(:two)).save!  # Add a second product to the cart from the products fixture.
    assert_equal 2, cart.line_items.size    # Assertion: there should be two line items in the cart.
    assert_equal (products(:one).price + products(:two).price), cart.total_price # Assertion: the sum of the prices of products one and two should be the same as when the total price method is called.
  end

  # Test cart can add duplicate products
  test "add duplicate products to the cart" do
    cart = Cart.new                            # Create a new cart.
    cart.add_product(products(:ruby)).save!    # Add the ruby book from the products fixture.
    cart.add_product(products(:ruby)).save!    # Add a second copy of the ruby book from the fixture.
    assert_equal 1, cart.line_items.size       # Assertion: there should only be one line item in the cart because we've only added one product.
    assert_equal (2 * products(:ruby).price), cart.total_price # Assersion: two time the price of the ruby book should be the same as a call to the total_price method.
    assert_equal 2, cart.line_items[0].quantity # Assertion: the quantity of products in the single line item should be two, there are two copies of the ruby book in the single line item.
  end
end
