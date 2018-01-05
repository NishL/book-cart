require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "BookCart order confirmation", mail.subject
    assert_equal ["billy@example.com"], mail.to
    assert_equal ["jib@example.com"], mail.from
    assert_match "Hi, I'm from order_mailer.rb", mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "BookCart Order Shipped", mail.subject
    assert_equal ["billy@example.com"], mail.to
    assert_equal ["jib@example.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end
