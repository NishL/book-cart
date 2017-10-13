class AddQuantityToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :quantity, :integer, default: 1 # Set default to 1 for exiting carts
  end
end
