class DiscountsController < ApplicationController
  def index
    @discounts = []
    @product_types = [ [ 'All', 0 ] ]
    @products = [ [ 'All', 0 ] ]

    product_types = {}
    products = {}

    ProductType.all.each do | product_type |
      product_types[ product_type.id ] = product_type.title
      @product_types << [ product_type.title, product_type.id ]
    end

    Product.all.each do | product |
      products[ product.id ] = product.title
      @products << [ product.title, product.id ]
    end

    Discount.all.order('id').each do | discount |
      @discounts << { product: products[ discount.product_id ] || '',
                      product_type: product_types[ discount.product_type_id ] || '',
                      quantity: discount.quantity,
                      percent: discount.percent,
                      value: discount.value,
                      active: discount.active,
                      id: discount.id
      }
    end
  end

  def destroy
    Discount.where( id: params[ :id ] ).destroy_all
    redirect_to discounts_path and return
  end

  def show
    discount = Discount.where( id: params[ :id ] ).first
    @discount = { product: discount.product_id,
                  product_type: discount.product_type_id,
                  quantity: discount.quantity,
                  percent: discount.percent,
                  value: discount.value,
                  active: discount.active,
                  id: discount.id
    }
    respond_to do |format|
      format.json { render :json => @discount }
    end
  end

  def update
    discount = Discount.where( id: params[ :id ] ).first
    if discount
      discount.product_id = params[ :products ].to_i == 0 ? nil : params[ :products ]
      discount.product_type_id = params[ :product_types ].to_i == 0 ? nil : params[ :product_types ]
      discount.quantity = params[ :quantity ]
      discount.percent = params[ :percent ]
      discount.value = params[ :value ]
      discount.active = params[ :active ]
      discount.save
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end

  def create
    discount = Discount.new
    discount.product_id = params[ :products ].to_i == 0 ? nil : params[ :products ]
    discount.product_type_id = params[ :product_types ].to_i == 0 ? nil : params[ :product_types ]
    discount.quantity = params[ :quantity ]
    discount.percent = params[ :percent ]
    discount.value = params[ :value ]
    discount.active = params[ :active ]
    discount.save
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
