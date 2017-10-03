require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "title is at least 10 characters long" do
    prod = Product.new(title: '123',
                       description: "yyy",
                       price: 1,
                       image_url: 'fred.gif')
    assert prod.invalid?
    assert prod.errors[:title].any?
    assert_equal ["That title isn't long enough"], prod.errors[:title]
  end
end
