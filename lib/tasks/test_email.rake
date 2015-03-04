desc "Test Email"
task :test_email => :environment do

  MailerGenerator.sample.deliver

end
