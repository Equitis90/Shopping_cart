class CartController < ApplicationController

  def show
    products = {}
    Product.all.each do | product |
      products[ product.id ] = { title: product.title, price: product.price }
    end

    @order_items = []
    OrderItem.where( order_id: params[ :id ] ).each do | order_item |
      @order_items = { product: products[ order_item.product_id ][ :title ],
                       quantity: order_item.quantity,
                       sum: order_item.quantity * products[ order_item.product_id ][ :price ],
                       id: order_item.id
      }
    end
  end

  def destroy
    OrderItem.where( order_id: params[ :id ] ).destroy_all
    Order.where( id: params[ :id ] ).destroy_all
    session[ :cart_id ] = nil
    redirect_to root_path and return
  end

  def create
    order = Order.create
    if order
      session[ :cart_id ] = order.id
      order_item = OrderItem.new
      order_item.product_id = params[ :product_id ]
      order_item.order_id = order.id
      order_item.quantity = params[ :quantity ]
      order_item.save
    end
    @order_sum = { sum: OrderItem.order_sum( session[ :cart_id ] ) }
    respond_to do |format|
      format.json { render :json => @order_sum }
    end
  end

  def update
    order = Order.where( id: session[ :cart_id ] ).first
    if order
      order_item = OrderItem.new
      order_item.product_id = params[ :product_id ]
      order_item.order_id = order.id
      order_item.quantity = params[ :quantity ]
      order_item.save
    end
    @order_sum = { sum: OrderItem.order_sum( session[ :cart_id ] ) }
    respond_to do |format|
      format.json { render :json => @order_sum }
    end
  end
end
