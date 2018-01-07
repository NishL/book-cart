require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
fixtures :products # We're testing the purchase of a product, so we only need to load the products fixture.

  # test "the truth" do
  #   assert true
  # end

  # 1) A user goes to the store index page.
  # 2) User selects a product, adding it to his/her cart.
  # 3) User checks out, filling in details in the checkout form.
  # 4) When user submits, and order is created in the database containing his/her info,
  #    along with a single line item corresponding to the product added to the cart.
  # 5) Once the order has been received, an email is sent confirming the purchase.

  test "buying a product" do
    # By the end of the test, we know that we'll want to have an order in the "orders" table
    # and a line item in the "line_items" table, so let's capture the number of orders before we start.
    start_order_count = Order.count

    # We'll be using the Ruby book from the products.yml fixture a lot, so let's
    # load it into a local variable.
    ruby_book = products(:ruby)

    # Now let's attack the user story.
    # 1) User goes to the store index page
    get "/"
    assert_response :success
    assert_select 'h1', 'Your Catalog'

    # 2) User selects a product, adding it to his/her cart.
    # We know that we use AJAX to add items to the cart so we need to use the
    # `xml_http_request()` or `xhr()` method to invoke the action.
    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # 3) User checks out
    get '/orders/new'
    assert_response :success
    assert_select 'legend', "Please Enter Your details"
  end
end
