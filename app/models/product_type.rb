class ProductType < ActiveRecord::Base
  belongs_to :products

  scope :get_type, ->(type) { where(title: type) }

  before_destroy :destroy_validation

  def destroy_validation
    raise "Can't delete product type, products exists!" unless Product.where( type_id: self.id ).first.nil?
  end
end
