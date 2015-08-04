class ProductsController < ApplicationController
  def index
    @product_types_list_present_only = []
    @product_types_list = [ ['All', 0] ]
    @product_types = {}
    @products = {}
    @product_type_id = 0
    ProductType.all.each do | p_t |
      @product_types[p_t.id] = p_t.title
      @product_types_list << [ p_t.title, p_t.id ]
      @product_types_list_present_only << [ p_t.title, p_t.id ]
    end

    product_query = Product.all
    if params[ :product_type_id ] && params[ :product_type_id ].to_i != 0
      @product_type_id = params[ :product_type_id ].to_i
      product_query = product_query.where( type_id: params[ :product_type_id ].to_i )
    end

    product_query.order( 'type_id' ).each do | product |
      @products[ product.type_id ] ||= []
      @products[ product.type_id ] << { title: product.title, price: product.price, active: product.active,
                                        id: product.id }
    end
  end

  def destroy
    Product.where( id: params[ :id ] ).destroy_all
    redirect_to products_path and return
  end

  def show
    product = Product.where( id: params[ :id ] ).first
    @product = { title: product.title, id: product.id, price: product.price, product_type_id: product.type_id,
                 active: product.active
    }
    respond_to do |format|
      format.json { render :json => @product }
    end
  end

  def update
    product = Product.where( id: params[ :id ] ).first
    if product
      product.title = params[ :title ]
      product.price = params[ :price ]
      product.type_id = params[ :product_type_id ]
      product.active = params[ :active ]
      product.save!
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end

  def create
    product = Product.new
    if product
      product.title = params[ :title ]
      product.price = params[ :price ]
      product.type_id = params[ :product_type_id ]
      product.active = params[ :active ]
      product.save!
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
