class CombineItemsInCart < ActiveRecord::Migration[5.0]
  # Iterate over each cart. For each cart find the sum of the quantity fields for
  # each line item in the cart, grouped by product_id. The resulting sums will be
  # a list of ordered pairs of product_id's and quantity.
  # Iterate over the sums extracting the product_id and quantity from each.
  # In cases where the quantity is greater than one, delete all of the individual
  # line items associated with this cart and this product and replace them with a
  # single line item with the correct quantity.
  def up
    # replace multiple items for a single product in a cart with a single item.
    Cart.all.each do |cart|
      # count the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single item
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  # Be able to reverse what we've done above (rollback the migration).
  # Find line items with a quantity greater than one; adds new line items for this
  # cart and product, each with a quantity of one; and finally, deletes the line item:
  def down
    # split items with a quantity>1 into multiple items
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          product_id: line_item.product_id,
          quantity: 1
        )
      end
      # remove the original item
      line_item.destroy
    end
  end

end
