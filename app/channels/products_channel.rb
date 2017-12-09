class ProductsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "products"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

# Take note of the channel class name: `ProductsChannel`, and the name of the
# stream: "products".
