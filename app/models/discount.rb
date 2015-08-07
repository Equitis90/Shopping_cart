class Discount < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  validates :quantity, :value, presence: true
  validates :value, :quantity, numericality: true

  before_validation :validate_product_types

  def validate_product_types
    if self.product_id && self.product_type_id
      errors.add :base, "You can't choose product and product type at once!"
      return false
    end
    if self.product_id.nil? && self.product_type_id.nil?
      errors.add :base, "You must choose product or product type!"
      return false
    end
  end
end
