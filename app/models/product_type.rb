class ProductType < ActiveRecord::Base
  belongs_to :product

  scope :get_type, ->(type) { where(title: type) }
end
