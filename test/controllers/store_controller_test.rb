require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select '#columns #side a', minimum: 4 # Look for element 'a' in element id 'side' contained in element 'columns', minimum of 4 such elements
    assert_select '#main .entry', 3              # Look for 3 elements with the id 'main'
    assert_select 'h3', 'Programming Ruby 2.4'   # Veify an h3 element with the title found in the fixture
    assert_select '.price', /\$[,\d]+\.\d\d/     # Verify the price is formatted properly
  end

end

# The type of test that `assert_select()` performs varies on the type of the second parameter.
# If it's a number, it's treated as a quantity.
# If it's a string, it's treated as an expected result.

# Explained: `assert_select '.price', /\$[,\d]+\.\d\d/`
# Verify the 'price' class is formatted properly using a regex.
# A) Verify that the price has a dollar sign with `\$`
# B) Verify that the dollar sign is followed by any number (at least 1), commas, or digits  with `[,\d]`
# C) Verify the above followed by a decimal point; followed by two digits with `+\.\d\d`

# http://api.rubyonrails.org/classes/ActionDispatch/Assertions/SelectorAssertions.html
# http://guides.rubyonrails.org/testing.html#testing-views
