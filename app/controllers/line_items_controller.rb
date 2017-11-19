class LineItemsController < ApplicationController
  include CurrentCart # Include current_cart from concerns and use priveate seet_cart()
  before_action :set_cart, only: [:create] # Invoke set_cart() before calling the create() action
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id]) # Use params object to get `:product_id` param passed in from the request on store#index.
    @line_item = @cart.add_product(product)     # Create the line item for the cart by using the `add_prouct()` method, pass in the product.

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart } # remove the flash message, notice: 'Line item was successfully created.' } # Add `.cart` to the method call, the line item object knows how to find the cart object
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    current_cart = session[:cart_id] # This can be use in place of @line_item.cart_id - TODO: figure out pros/cons of each
    respond_to do |format|
      format.html { redirect_to cart_path(@line_item.cart_id), notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id) # Remove :cart_id from permitted params to prevent access to other people's carts.
    end
end
