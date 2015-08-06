class CartController < ApplicationController

  def show
    recalc_discount( params[ :id ] )
    @product_types = {}
    ProductType.all.each do | p_t |
      @product_types[ p_t.id ] = p_t.title
    end

    products = {}
    Product.all.each do | product |
      products[ product.id ] = { title: product.title, price: product.price, product_type_id: product.type_id }
    end

    @order_items = {}
    OrderItem.where( order_id: params[ :id ] ).order( :product_id ).each do | order_item |
      sum = order_item.quantity * products[ order_item.product_id ][ :price ]
      @order_items[ products[ order_item.product_id ][ :product_type_id ] ] ||= []
      @order_items[ products[ order_item.product_id ][ :product_type_id ] ] << {
          product: products[ order_item.product_id ][ :title ],
          quantity: order_item.quantity,
          sum: sum,
          id: order_item.id,
          product_id: order_item.product_id
      }
    end
    order = Order.where( :id => params[ :id ] ).first
    @total_sum = order.total
    @total_discount = order.discount
    @sum_with_discount = @total_sum - @total_discount
  end

  def destroy
    begin
      OrderItem.where( order_id: params[ :id ] ).destroy_all
      Order.where( id: params[ :id ] ).destroy_all
      session[ :cart_id ] = nil
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
    redirect_to root_path and return
  end

  def create
    order = Order.create
    if order
      begin
        session[ :cart_id ] = order.id
        order_item = OrderItem.new
        order_item.product_id = params[ :product_id ]
        order_item.order_id = order.id
        order_item.quantity = params[ :quantity ]
        order_item.save!
      rescue Exception => e
        flash[ :danger ] = e.to_s
      end
    end
    @order_sum = { sum: OrderItem.order_items_count( session[ :cart_id ] ) }
    respond_to do |format|
      format.json { render :json => @order_sum }
    end
  end

  def update
    order = Order.where( id: session[ :cart_id ] ).first
    if order
      begin
        if params[ :order_item_id ]
          order_item = OrderItem.where( id: params[ :order_item_id ] ).first
          if params[ :quantity ].to_i == 0
            OrderItem.where( id: order_item.id ).destroy_all
          else
            order_item.quantity = params[ :quantity ]
            order_item.save!
          end
        else
          order_item = OrderItem.where( product_id: params[ :product_id ] ).first
          if order_item
            order_item.quantity += params[ :quantity ].to_i
            order_item.save!
          else
            order_item = OrderItem.new
            order_item.product_id = params[ :product_id ]
            order_item.order_id = order.id
            order_item.quantity = params[ :quantity ]
            order_item.save!
          end
        end
      rescue Exception => e
        flash[ :danger ] = e.to_s
      end
    end
    @order_items_count = { sum: OrderItem.order_items_count( session[ :cart_id ] ) }
    respond_to do |format|
      format.json { render :json => @order_items_count }
    end
  end

  def remove_product_from_cart
    begin
      OrderItem.where( id: params[ :id ] ).destroy_all
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
    redirect_to cart_path( id: session[ :cart_id] ) and return
  end

  def recalc_discount( order_id )
    discounts = []
    Discount.active.each do | discount |
      discounts << { product_id: discount.product_id,
                     product_type_id: discount.product_type_id,
                     quantity: discount.quantity,
                     percent: discount.percent,
                     value: discount.value,
                     total: discount.total
      }
    end

    product_types_id = {}
    product_prices = {}
    Product.all.each do | product |
      product_types_id[ product.id ] = product.type_id
      product_prices[ product.id ] = product.price
    end

    total_percent_discount = 0
    total_value_discount = 0
    order = Order.where( :id => order_id ).first

    if order
      total_price = 0
      OrderItem.where( :order_id => order.id ).each do | order_item |
        item_price = product_prices[ order_item.product_id ] * order_item.quantity
        total_price += item_price

        discounts.each do | discount |
          if discount[ :product_id ] == order_item.product_id || discount[ :product_type_id ] == product_types_id[ order_item.product_id ]
            if order_item.quantity >= discount[ :quantity ]
              if discount[ :percent ]
                percent_value = discount[ :value ] * 0.01
                if discount[ :total ]
                  total_percent_discount += percent_value
                else
                  item_discount = item_price * percent_value
                  total_value_discount += item_discount
                end
              else
                if discount[ :total ]
                  total_value_discount += discount[ :value ]
                else
                  item_discount = item_price - discount[ :value ]
                  total_value_discount += item_discount
                end
              end
            end
          end
        end
      end

      percent_discount = (total_price - total_value_discount) * total_percent_discount
      total_discount = total_value_discount + percent_discount

      unless order.total == total_price && order.discount == total_discount
        begin
          order.total = total_price
          order.discount = total_discount
          order.save
        rescue Exception => e
          flash[ :danger ] = e.to_s
        end
      end
    end
  end
end
