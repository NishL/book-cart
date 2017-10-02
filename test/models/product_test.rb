require 'test_helper'

# We can test the model's validation.
# If we create a product with no attributes set, we'll expext it to be invalid,
# and for an error to be associated with each field.

# We can use the model's `errors()` and `invalid?()` methods to see if it validates.
# We can use the `any?()` method of the error list to see if an error is associated
# with a particular attribute.

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Test an empty product is invalid.
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  # Check validation of price works.
  test "product price must be positive" do
    product = Product.new(title:       "My book title",
                          description: "yyy",
                          image_url:   'zzz.jpg')

    # It's reasinable to put the following three tests into
    # three separate test methods.
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  # Test image_url ends with .png, .jpg, or .gif
  def new_product(image_url)
    Product.new(title: "My book title",
                description: "yyy",
                price: 1,
                image_url: image_url)
  end

  test "image url" do
    # Array of accepable file names
    ok = %w{ fred.gif fred.png fred.jpg FRED.jpg FRED.png http://a.b.c/x/y/z/fred.gif }

    # Array of unacceptable file names
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    # Loop through all of the 'ok' file names and make assertions,
    # pass a string to the assertion in case the test fails, you'll know
    # what the problem was.
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
end

# http://api.rubyonrails.org/classes/ActiveModel/Errors.html
