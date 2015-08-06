class Product < ActiveRecord::Base
  has_one :product_type

  scope :active, -> { where(active: true) }

  before_destroy :destroy_validation

  def destroy_validation
    raise "Can't delete product, orders exists!" unless OrderItem.where( product_id: self.id ).first.nil?
  end
end
