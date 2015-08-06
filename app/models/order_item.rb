class OrderItem < ActiveRecord::Base
  belongs_to :products
  belongs_to :order

  scope :order_items_count, ->(order_id) { where(order_id: order_id).sum(:quantity) }

  validates :product_id, :order_id, :quantity, presence: true
end
