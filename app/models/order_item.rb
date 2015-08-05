class OrderItem < ActiveRecord::Base
  belongs_to :products
  belongs_to :order

  scope :order_sum, ->(order_id) { where(order_id: order_id).sum(:quantity) }
end
