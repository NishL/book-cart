App.products = App.cable.subscriptions.create "ProductsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".store #main").html(data.html)
    # Called when there's incoming data on the websocket for this channel

    # Receive the data on the client. We subscribe to the channel and define
    # what happens to the data we receive.
    # The code creates a subscription to the `ProductsChannel` and defines
    # functions that are called whenever the channel is connected or disconnected,
    # or when data is received.
    # HOW IT WORKS:
    # 1) We update the `received` function with a line of code that looks for an
    #    html element with an ID of main that's contained within another element
    #    with a class of store.
    # 2) If such an eleent is found, it will replace the HTML contents of that element
    #    with the data received from the channel.
    # This will leave the rest of the page alone and have no effect on pages other than
    # the storefront.
