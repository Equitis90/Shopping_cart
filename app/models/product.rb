class Product < ActiveRecord::Base
  has_one :product_type

  scope :active, -> { where(active: true) }
end
