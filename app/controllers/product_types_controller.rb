class ProductTypesController < ApplicationController
  def index
    @product_types = []

    ProductType.all.order('id').each do | product_type |
      @product_types << { title: product_type.title, id: product_type.id }
    end
  end

  def destroy
    begin
      ProductType.where( id: params[ :id ] ).destroy_all
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
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
      begin
        product_type.title = params[ :title ]
        product_type.save!
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
      product_type = ProductType.new
      product_type.title = params[ :title ]
      product_type.save!
    rescue Exception => e
      flash[ :danger ] = e.to_s
    end
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
