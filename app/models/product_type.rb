class ProductType < ActiveRecord::Base
  belongs_to :products

  scope :get_type, ->(type) { where(title: type) }
end
