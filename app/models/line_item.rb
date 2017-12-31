class LineItem < ApplicationRecord
  belongs_to :order, optional: true # An order has line_items
  belongs_to :product, optional: true # A line_item will reference a product
  belongs_to :cart

  def total_price
    product.price * quantity
  end
end

# With LineItem, the database now has a place to store the references among
# line items, carts, and products. This file defines the relationship between
# them.
# At the model level there's no difference between a simple reference and a
# `belongs_to()` relationship. Both are implemented with the `belongs_to()` method.

# In this "LineItem" model, the two `belongs_to()` calls tells Rails that the rows
# in the `line_items` table are children of the rows in the "carts" & "products"
# table. No line item can exist unless the corresponding cart and product rows exist.

#######
# Tip #
#######

# An easy way to remember where to put `belongs_to()` declarations:
# If a table has any columns whose values consist of ID values for another table (known
# as "foreign keys" by DB designers), the corresponding model should have a `belongs_to()`
# for each.

# What do these declarations do? They add navigation capabilities to the model objects.
# Rails added the `belongs_to()` declaration to `LineItem`, we can now retreive its
# `Product` and display the book's title:
#
# li = LineItem.find(...)
# puts "This line item is for #{li.product.title}"

# To be able to traverse these relationships in both directions, we need to add
# `has_many()` declarations to our model files that specify their inverse relations.
