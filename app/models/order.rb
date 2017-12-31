class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy # An order has many line_items, which are destroyed when the order is complete or cancelled.

  enum pay_type: {
    "Cheque" => 0,
    "Credit Card" => 1,
    "Purchase Order" => 2
  }

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  # Since we have included the CurrentCart module in the Orders controller
  # we will have access to the @cart object.
  # For each item we transfer from the cart to the order, we have to do two things:
  # 1) we set the cart_id to nil to prevent the item from disappearing when we destroy the cart
  # 2) then we add the item to the line_items collection for the order.
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil # change the items cart_id to nil (no longer associated with a cart)
      line_items << item # shovel the item into the collection for the order.
    end
  end
end
