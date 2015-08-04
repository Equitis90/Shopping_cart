class OrderItem < ActiveRecord::Base
  belongs_to :products
  belongs_to :order
end
