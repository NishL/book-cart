class Product < ApplicationRecord
  # Validate data before writing to DB.
  validates :title, :description, :image_url, presence: true

  # Validates price is valid positive number
  # Test against 0.01 instead of 0: DB store 2 digits after decimal.
  # If user enters 0.001 it would be stored as 0.00.
  validates :price, numericality: {greater_than_or_equal_to: 0.01}

  # Validate a unique title. No 2 title should be the same.
  validates :title, uniqueness: true
  validates :title, length: { minimum: 10, message: "That title isn't long enough" }

  # Validate the image url ends with .gif, .jpg, or .png.
  # Use 'format' option to match regex.
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
end
