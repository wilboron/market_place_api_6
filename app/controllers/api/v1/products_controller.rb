class Api::V1::ProductsController < ApplicationController
  include Paginable

  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: %i[create update destroy]
  before_action :check_owner, only: %i[update destroy]

  def show
    render json: serialize(@product, include_user: true)
  end

  def index
    @products = Product.page(current_page)
                       .per(per_page)
                       .search(params)

    options = links_serializer_options('api_v1_products_path', @products)

    render json: serialize(@products, options: options)
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: serialize(product), status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: serialize(@product)
    else
      render json: @product.erros, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def serialize(product, include_user: false, options: {})
    if include_user
      ProductSerializer.new(product, include: [:user]).serializable_hash
    else
      ProductSerializer.new(product, options).serializable_hash
    end
  end
end
