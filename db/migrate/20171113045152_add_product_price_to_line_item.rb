class AddProductPriceToLineItem < ActiveRecord::Migration[5.0]
  # Add a price column to the line_items table.
  # Loop through the existing line_items and add the price to each.
  def change
    add_column :line_items, :price, :decimal, precision: 8, scale: 2

    LineItem.all.each do |line_item|
      line_item.price = line_item.product.price
      # line_item.save
    end

  end
end
