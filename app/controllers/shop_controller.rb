class ShopController < ApplicationController
  def index
    @product_types_list = [ ['All', 0] ]
    @product_types = {}
    @products = {}
    @product_type_id = 0
    ProductType.all.each do | p_t |
      @product_types[p_t.id] = p_t.title
      @product_types_list << [ p_t.title, p_t.id ]
    end

    product_query = Product.active
    if params[ :product_type_id ] && params[ :product_type_id ].to_i != 0
      @product_type_id = params[ :product_type_id ].to_i
      product_query = product_query.where( type_id: params[ :product_type_id ].to_i )
    end

    product_query.order( 'type_id' ).each do | product |
      @products[ product.type_id ] ||= []
      @products[ product.type_id ] << { title: product.title, price: product.price, id: product.id }
    end
  end
end
