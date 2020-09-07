class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def show
    render json: @product
  end

  def index
    render json: Product.all
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
