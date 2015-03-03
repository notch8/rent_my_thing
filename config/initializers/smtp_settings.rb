ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :user_name => "rent.my.thing@gmail.com",
    :password => "SDlearn123",
    :domain => "gmail.com",
    :authentication => "plain",
    :enable_starttls_auto => true
}
