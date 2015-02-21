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

   def send_feedback(userName, comment)

      # Send feedback from user to support

      email_body = 'From: ' + userName + '<br/><br/>Comments:<br/>' + comment
      send_mail("support@#{Rails.application.config.domain_name}", Rails.application.config.app_name + ' Comment', email_body)

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
                    :body => email_body,
                    :html_body => wrap_html(email_body),
                    :from => 'support@' + Rails.application.config.domain_name
                })

   end

   def send_production_email(email_address, subject, email_body)

      # Use API to interact with Heroku add-on Postmark
      # http://developer.postmarkapp.com/developer-send-api.html
      # Substitute 'POSTMARK_API_TEST' for postmark_token to test and not send actual emails


      uri = URI('https://api.postmarkapp.com/email')


      # Form the request
      req = Net::HTTP::Post.new(uri)

      # Set request headers
      req['Accept'] = 'application/json'
      req['Content-Type'] = 'application/json'
      req['X-Postmark-Server-Token'] = Rails.application.config.postmark_token

      rbody ={
          'From' => 'Support <michael@disambiguator.com>', # TODO: replace email when domain is live
          'To' => email_address,
          'Subject' => subject,
          'HtmlBody' => wrap_html(email_body),
          'TextBody' => email_body
      }.to_json

      req.body = rbody

      # Send the request, waiting for the response
logthis('send request')
      begin
         response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
      rescue Exception => e
         logthis("http request error: #{e.message}")
         return
      end


      # Translate response from JSON to string array
logthis('decode response')
      parsed_response = ActiveSupport::JSON.decode(response)

      # Log the HTTP response
      code = parsed_response[0]['ErrorCode']
      msg = parsed_response[0]['Message']

      logthis("Postmark email response: #{code} #{msg}")

   end

   def wrap_html(msg)
      # Wrap email message in basic html

      return '<div>' + msg + '</div>'

   end

end
