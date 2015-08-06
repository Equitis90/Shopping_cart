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
                      total: discount.total,
                      id: discount.id
      }
    end
  end

  def destroy
    begin
      Discount.where( id: params[ :id ] ).destroy_all
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
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
                  total: discount.total,
                  id: discount.id
    }
    respond_to do |format|
      format.json { render :json => @discount }
    end
  end

  def update
    discount = Discount.where( id: params[ :id ] ).first
    if discount
      begin
      discount.product_id = params[ :products ].to_i == 0 ? nil : params[ :products ]
      discount.product_type_id = params[ :product_types ].to_i == 0 ? nil : params[ :product_types ]
      discount.quantity = params[ :quantity ]
      discount.percent = params[ :percent ]
      discount.value = params[ :value ]
      discount.active = params[ :active ]
      discount.total = params[ :total ]
      discount.save!
      rescue Exception => e
        flash[ :danger ] = e.to_s
      end
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end

  def create
    begin
      discount = Discount.new
      discount.product_id = params[ :products ].to_i == 0 ? nil : params[ :products ]
      discount.product_type_id = params[ :product_types ].to_i == 0 ? nil : params[ :product_types ]
      discount.quantity = params[ :quantity ]
      discount.percent = params[ :percent ]
      discount.value = params[ :value ]
      discount.active = params[ :active ]
      discount.total = params[ :total ]
      discount.save!
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
