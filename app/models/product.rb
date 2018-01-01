class Product < ApplicationRecord
  has_many :line_items # We have lots of carts, each product may have many line items referencing it
  has_many :orders, through: :line_items # Declare that there is a relationship between products & orders *through* the line_items relationship. Useful in the atom feed.

  before_destroy :ensure_not_referenced_by_any_line_item # Prevent removal of products referenced by line items

  # Validate data before writing to DB.
  validates :title, :description, :image_url, presence: true

  # Validates price is valid positive number
  # Test against 0.01 instead of 0: DB store 2 digits after decimal.
  # If user enters 0.001 it would be stored as 0.00.
  validates :price, numericality: {greater_than_or_equal_to: 0.01}

  # Validate a unique title. No 2 titles should be the same.
  validates :title, uniqueness: true
  validates :title, length: {minimum: 10, message: "isn't long enough"}

  # Validate the image url ends with .gif, .jpg, or .png.
  # Use 'format' option to match regex.
  # The 'Z' in the regex matches the end of the string before '\n' and
  # the 'i' means the regex pattern match is case insensitive.
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  validates :image_url, uniqueness: true

  private

  # Ensure that there are no line items referencing this product.
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end

end

# We declare that a Product has many line items and defined a 'hook' method named
# `ensure_not_referenced_by_any_line_item()`.

# A 'hook' method is a method that Rails calls automatically at a given point in an
# object's life. In this case, the method gets called before Rails attempts to destroy
# a row in the database. If the hook throws `abort`, the row isn't destroyed.

# 1) http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
# 2) http://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_length_of
# 3) http://guides.rubyonrails.org/active_record_validations.html
