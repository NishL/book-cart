class Order < ApplicationRecord
  enum pay_type: {
    "Cheque" => 0,
    "Credit Card" => 1,
    "Purchase Order" => 2
  }
end
