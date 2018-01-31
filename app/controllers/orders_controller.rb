class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create] # We need to allow users to create orders, which includes access to the new form.
  include CurrentCart # Make sure we have access to the cart in the session.
  before_action :set_cart, only: [:new, :create] # Before creating a new order, make sure there's a cart.
  before_action :ensure_cart_isnt_empty, only: :new # Before creating a new order, make sure the cart isn't empty.
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    @order.add_line_items_from_cart(@cart) # Add all the line_items from a cart to the order.

    respond_to do |format|
      if @order.save                    # Tell the order to save itself to the database, if it does, then do the following.
        Cart.destroy(session[:cart_id]) # When the order is saved, destroy the cart from the session, it's no longer needed.
        session[:cart_id] = nil         # Set the session cookie for the cart_id to nil, until another cart is created.
        OrderMailer.received(@order).deliver_later # Tell the OrderMailer to send the 'received email' after save.
        format.html { redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks') } # Redirect the user to the store index, let them know that the order was placed.
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity } # If the save fails then we tell the user why on the checkout page.
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Check to make sure the cart isn't empty.
    # If there's nothing in the cart, redirect the user back to the store.
    def ensure_cart_isnt_empty
      if @cart.line_items.empty?
        redirect_to store_index_url, notice: "Your cart is empty!"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end

# WHY ARE THERE TWO @order MODEL OBJECTS (in the `new` and `create` actions)?
# ANSWER: The `new` action creates an Order object in **memory** simply to give the template code something to work with.
#         The `create` action create an Order object, filling in attributes from the form fields. This object actually
#         gets **saved** to the database.
#         Model objects perform two roles:
#         1) They map data into and out of the database
#         2) They're regular objects that hold business date
#         Model objects only affext the database when you tell them to, typically by calling `save()`.
