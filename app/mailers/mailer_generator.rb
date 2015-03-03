class MailerGenerator < ActionMailer::Base
  default from: "customer_service@rent-my-thing.com"
  layout 'mailer'

  def sample
    mail( :to => "jmo@olen-inc.com", :subject => "testing email from rent_my_thing")
  end

end
