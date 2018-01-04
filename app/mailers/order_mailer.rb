class OrderMailer < ApplicationMailer
  default from: 'Jim Bob <jib@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @greeting = "Hi, I'm from order_mailer.rb"
    @order = order

    mail to: order.email, subject: "BookCart order confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped
    @greeting = "Hi"

    mail to: "to@example.org"
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
