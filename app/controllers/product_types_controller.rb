class ProductTypesController < ApplicationController
  def index
    @product_types = []

    ProductType.all.order('id').each do | product_type |
      @product_types << { title: product_type.title, id: product_type.id }
    end
  end

  def destroy
    ProductType.where( id: params[ :id ] ).destroy_all
    redirect_to product_types_path and return
  end

  def show
    product_type = ProductType.where( id: params[ :id ] ).first
    @product_type = { title: product_type.title, id: product_type.id }
    respond_to do |format|
      format.json { render :json => @product_type }
    end
  end

  def update
    product_type = ProductType.where( id: params[ :id ] ).first
    if product_type
      product_type.title = params[ :title ]
      product_type.save!
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end

  def create
    product_type = ProductType.new
    product_type.title = params[ :title ]
    product_type.save!
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
