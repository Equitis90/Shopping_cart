class Order < ActiveRecord::Base
  has_many :products

  before_destroy :destroy_validation

  def destroy_validation
    raise "Can't delete cart, order items exists!" unless OrderItem.where( order_id: self.id ).first.nil?
  end
end
