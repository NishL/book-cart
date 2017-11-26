require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }

      follow_redirect!

      assert_select 'h2', 'Your Cart'
      assert_select 'td', "Programming Ruby 2.4"
    end

    # assert_redirected_to line_item_url(LineItem.last)
  end

  test "should create line_item via AJAX" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true # xhr stands for XMLHttpRequest.
    end

    assert_response :success # Instead of a redirect, we expect as successful response containing a call to replace the HTML in the cart.
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Programming Ruby 2.4/ # In the HTML, we expect to find a row with an ID 'current_item'.
    end
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to cart_url
    # NOTE: If I'm redirecting to the store_index_url after removing a line_item, then I would use the following test instead:
    # `assert_redirected_to store_index_url`
  end
end
