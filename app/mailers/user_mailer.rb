class UserMailer < ApplicationController

   def send_welcome_email(account)

      # Create email body
      email_body = "Welcome to #{Rails.application.config.app_name}!" +
          '<br/><br/>Site url: <a 	  href="http://' + Rails.application.config.domain_name + '">' + Rails.application.config.app_name + '</a>' +
          '<br/><br/>User name: ' + account.username +
          '<br/>Email address: ' + account.email_address +
          '<br/><br/> We hope this service will save you a lot of time.' +
          '<br/>Please tell your friends!'

      # Send the email
      send_mail account.email_address, 'Welcome to ' + Rails.application.config.app_name, email_body

   end

   def send_password_reset_email(account)

      # Create email body
      email_body = 'Hello, ' + account.first_name + '.<br /><br />Looks like you requested a password reset.' +
          '<br/><br/>Click <a href="http://' + Rails.application.config.domain_name + "/person/reset_password?prt=#{ account.password_reset_token}" + '>here</a> to reset your password.'

      # Send the email
      send_mail account.email_address, 'Password Reset', email_body

   end

   def send_profile_changed_email(account)

      # Create email body
      email_body = 'Hello, ' + account.first_name + '.<br /><br />Your profile was just updated at ' + Rails.application.config.domain_name + '.'

      # Send the email
      send_mail account.email_address, 'Profile Changed', email_body

   end

   def send_feedback(email_address, comment)

      # Send feedback from user to support

      email_body = 'From: ' + email_address + '<br/><br/>Comments:<br/>' + comment
      send_mail('michael@disambiguator.com', Rails.application.config.app_name + ' Comment', email_body)
      # TODO: change email to support@#{Rails.application.config.domain_name}
   end

   def send_mail(email_address, subject, email_body)

      if Rails.env == 'production'
         send_production_email(email_address, subject, email_body)
      else
         send_test_email(email_address, subject, email_body)
      end

   end

   def send_test_email(email_address, subject, email_body)

      # letter_opener creates local files and opens them in the browser to prevent email sending during development
      require 'letter_opener'

      # Send email using Pony gem
      # Documentation: https://github.com/benprew/pony

      Pony.options = {
          :via => LetterOpener::DeliveryMethod,
          :via_options => { :location => File.expand_path('../tmp/letter_opener', __FILE__) }
      }

      Pony.mail({
                    :to => email_address,
                    :subject => subject,
                    :body => replace_html(email_body),
                    :html_body => email_body,
                    :from => 'support@' + Rails.application.config.domain_name
                })

   end

   def send_production_email(email_address, subject, email_body)

      # Use 'postmark' gem to interact with Heroku add-on Postmark
      # https://github.com/wildbit/postmark-gem

      begin
         client = Postmark::ApiClient.new(Rails.application.config.postmark_token)

         from_addr = Rails.application.config.app_name + ' <michael@disambiguator.com>' # TODO: replace email when domain is live

         client.deliver(from: from_addr,
                        to: email_address,
                        subject: subject,
                        text_body: replace_html(email_body),
                        html_body: email_body)
      rescue Exception => e
         logthis("Postmark email error: #{e.message}")
         return
      end

   end

   def replace_html(msg)
      # Replace html tags with pure text characters

      msg = msg.gsub('<div>', 13.chr + 10.chr) # <div> to CR+LF
      msg = msg.gsub('</div>', 13.chr + 10.chr) # </div> to CR+LF
      msg = msg.gsub('</br>',13.chr + 10.chr) # <br> to CR+LF
      return msg

   end

end
