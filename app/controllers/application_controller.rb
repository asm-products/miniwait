class ApplicationController < ActionController::Base

   def logthis(msg)
      logger.debug "\n===================================="
      logger.debug msg
      logger.debug "====================================\n"
   end

  def validate_password(password)
     # Returns "" or an error message about the password rules
     # regex (=~) returns the position of the matching string, so zero is good
     if (password =~ /([a-zA-Z0-9_.@#&+=]{5,99})/) == 0
	    return ""
	 else
	    return "Password must be 5+ letters, numbers or special characters (_.@#&+=)"
	 end
  end
  
  def check_authenticated(functionName)
     if session[:user_id].nil?
	    begin
	       raise "Cannot use #{functionName} without being logged in."
		rescue Exception => e
		   show_error(e)
		end
	 end
  end
  
   def show_error(exc)

     logthis(exc.message)
	 @errorMessage = exc.message
	 @stackTrace = exc.backtrace
	
	 # html page "show_error" displays error and offers login
	 render 'show_error' and return
	
	 return
	
   end

   def report_error
      if params[:error_message].present?
         mailer = UserMailer.new()
         mailer.send_error_report(params[:email], params[:comment], params[:error_message], params[:stack_trace])
         flash[:user_message] = 'Thank you for your feedback.'
      end

      redirect_to :controller => 'home', :action => 'show'

   end

   def feedback

      # populate user email if they are logged in (it's just polite)
      if session[:user_id]
         @person = Person.find(session[:user_id])
      else
         @person = Person.new
      end


      if request.post?

         if (params[:email].blank? || params[:comment].blank?)
            flash[:user_message] = 'Please enter an email address and your comment before submitting.'
         else
            mailer = UserMailer.new()
            mailer.send_feedback(params[:email], params[:comment])
            flash[:user_message] = 'Thank you for your feedback.'
         end
         render 'feedback'
      else
         # fall through to feedback form
      end
   end

   def my_ip_address
      require 'socket'
      list=Socket.ip_address_list
      ip = list.detect{|intf| intf.ipv4_private?}
logthis("IP: #{ip}")
      ip.ip_address if ip
   end

   def test_error
      begin
         x = 1/0
      rescue Exception => e
         show_error(e)
      end
   end

   at_exit do
      if $!
         show_error($!)
      end
   end
end
