require 'test_helper'

# We can test the model's validation.
# If we create a product with no attributes set, we'll expext it to be invalid,
# and for an error to be associated with each field.

# We can use the model's `errors()` and `invalid?()` methods to see if it validates.
# We can use the `any?()` method of the error list to see if an error is associated
# with a particular attribute.
# http://api.rubyonrails.org/classes/ActiveModel/Errors.html

class ProductTest < ActiveSupport::TestCase
  # fixtures :products # Load the products.yml fixture instead of default: Rails loading all fixtures.
  # test "the truth" do
  #   assert true
  # end

  # Test an empty product is invalid.
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?                      # In Rails console try: `product.errors.messages`.
    assert product.errors[:description].any?                # You'll understand that the error messages are saved
    assert product.errors[:price].any?                      # in a hash. Make sure to try saving a product in console first.
    assert product.errors[:image_url].any?
  end

  # Check validation of title length
  test "title must be at least 10 characters" do
    prod = Product.new(title: '123',
                       description: 'yyy',
                       price: 1,
                       image_url: 'fred.png')
    assert prod.invalid?
    assert prod.errors[:title].any?
    assert_equal ["isn't long enough"], prod.errors[:title]
  end

  # Check validation of price works.
  test "product price must be positive" do
    product = Product.new(title:       "My book title",
                          description: "yyy",
                          image_url:   'zzz.jpg')

    # It's reasonable to put the following three tests into
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

  # Test unique product name validation.
  # For this test to work, we need to store product data in the database.
  # To achieve this we can create a test product, save it, then create another
  # on with the same name. OR, we can use 'fixtures'.
  # test/fixtures/products.yml
  # For each fixture loaded into a test, Rails defines a method with the same name
  # as the fixture (ex. `products`). You can use this method to access preloaded model
  # objects containing the fixture data: simply pass it the name of the row as defined
  # in the YAML fixture file. In our case we'll call `products(:ruby)` which will return
  # a `Product` model containg the fixture data we defined.
  test "product is not valiid without a unique title" do
    product = Product.new(title: products(:ruby).title, # Create a new product with the same title as one from fixture.
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
end
