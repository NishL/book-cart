require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products # We're testing the purchase of a product, so we only need to load the products fixture.
                     # If we leave out this line then all of the fixtures are loaded, that can slow down your tests
                     # if they aren't needed.
  include ActiveJob::TestHelper

  # test "the truth" do
  #   assert true
  # end

  # Here is the user story:
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
    # second = products(:one) NOTE: the test would fail if we added a second product to the cart and only tested for 1 item in the cart

    # Now let's attack the user story.
    # 1) User goes to the store index page
    # This is different from a functional test where only one controller is checked.
    # An integration test is all over the place, so we pass a full (relative) URL for and the action to be invoked.
    get "/"
    assert_response :success
    assert_select 'h1', 'Your Catalog'

    # 2) User selects a product, adding it to his/her cart.
    # We know that we use AJAX to add items to the cart so we need to use the
    # `xml_http_request()` or `xhr()` method to invoke the action.
    post '/line_items', params: { product_id: ruby_book.id }, xhr: true

    # post '/line_items', params: { product_id: second.id }, xhr: true NOTE: the test would fail if we added a second product to the cart and only tested for 1 item in the cart
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # 3) User checks out
    get '/orders/new'
    assert_response :success
    assert_select 'legend', "Please Enter Your Details"

    # 4) User submits order, they receive an email
    # POST the for data to the save order action and verify the redirect.
    perform_enqueued_jobs do
    post '/orders/', params: {
      order: {
        name: "James Murphy",
        address: "123 Any Street",
        email: "james@example.com",
        pay_type: "Cheque"
      }
    }

    # After the order is save, user is redirected back to the store (home/index).
    follow_redirect!
    assert_response :success
    assert_select 'h1', "Your Catalog"
    # The cart should now be empty.
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # Now we'll check the database to make sure we've created an order with the
    # correct details.
      assert_equal start_order_count + 1, Order.count # Check that there's one more order for when we started.
      order = Order.last

      # Test the last order matches what we expect
      assert_equal "James Murphy", order.name
      assert_equal "123 Any Street", order.address
      assert_equal "james@example.com", order.email
      assert_equal "Cheque", order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product

      # Finally, we test to make sure that the mail is addressed correctly and has
      # the expected data.
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["james@example.com"], mail.to
      assert_equal "Jim Bob <jib@example.com>", mail[:from].value
      assert_equal ["jib@example.com"], mail.from
      assert_equal "BookCart order confirmation", mail.subject

    end
  end
end
