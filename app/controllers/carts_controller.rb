class CartsController < ApplicationController
  skip_before_action :authorize, only: [:create, :update, :show, :destroy] # We need to allow users to create, update and empty carts without authentication
  before_action :set_cart, only: [:show, :edit, :update, :destroy] # NOTE: before calling the actions in the array call set_cart
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    # Ensure that the user only deletes their own cart.
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_index_url } # Redirect to the store index, we don't need a notice anymore, it's clear to the user when the cart is empty
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end

    # Rescue feom ActiveRecord::RecordNotFound
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_index_url, notice: 'Ivalid Cart'
    end
end

# NOTE: The `rescue_from` clause intrcepts the exception raised by `Cart.find()`.
# In the handler we do the following:
# 1) Use the Rails logger to record the error. Every controller has a logger attribute,
#    here we use it to record a  message at the `error` logging level.
# 2) Rdirect to the catalog display using the `redirect_to()` method. The `:notice`
#    parameter specifies a message to be stored in the flash as a notice.
