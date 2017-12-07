module ApplicationHelper
    # This method accepts a condtion, an optional set of attributes, and a block.
    def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none" # If the condtion is true then the div tag will have a style condition of 'display: none'. We check in @cart.line_items.empty?
    end
    content_tag("div", attributes, &block) # Use the content_tag to wrap the output in a block, in this use case, wrapped in a div with an id="cart"
  end
end
