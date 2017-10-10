class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
end

# `has_many()` should be self explanatory: a cart potentially has many
# associated line items. These are linked to the cart because each line item
# has a reference to its cart's ID.

# `dependent: :destroy` indicates that the existence of a line item is dependent
# on the existence of the cart.

# If we destroy a cart (deleting it from the database), then we also want to
# destroy the line items associated with that cart.

# Now that `Cart` is declared to have many line items, we can reference them
# (as a collection) from a cart object:
#
# cart = Cart.find(...)
# puts "This cart has #{cart.line_items.count} line items."