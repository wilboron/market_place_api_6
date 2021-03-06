class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :check_login, only: %i[update destroy]
  before_action :check_owner, only: %i[update destroy]
  # GET /users/1
  def show
    render json: serialize_user(include_product: true)
  end

  # GET /users
  def index
    render json: User.all
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: serialize_user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: serialize_user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  # Only allow a trusted parameter 'allowed list' through
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end

  def serialize_user(include_product: false)
    if include_product
      UserSerializer.new(@user, include: [:products]).serializable_hash
    else
      UserSerializer.new(@user).serializable_hash
    end
  end
end
