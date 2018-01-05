class OrderMailer < ApplicationMailer
  default from: 'Jim Bob <jib@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order) # Modify received method to take an argument
    @greeting = "Hi, I'm from order_mailer.rb"
    @order = order # Added this line to copy the argument passed into an instance variable. This param is passed in from the orders_conrtoller create() action

    mail to: order.email, subject: "BookCart order confirmation" # Modified the call to mail() specifying where to send the email and the subject line.
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order # This instance variable, along with the one in the received() method are only used in the mailer template files.

    mail to: order.email, subject: "BookCart Order Shipped"
  end
end

# This file is kind of like a controller for emails. It includes one method per action.
# Instead of a call to render(), there's a call to mail().
# The mail() method accepts a number of parameters like :to, :cc, :from and :subject, each does
# exactly what you expect.
# Values that are common to all mail() calls in the mailer can be set as defaults by calling
# default() as we have done with :from at the top of this file.
# There are two email templates that were created for each action in this OrderMailer class,
# they are found in app/views/order_mailer. There are erb files for both plain-text and HTML
# emails.

# See http://guides.rubyonrails.org/action_mailer_basics.html for the docs.
