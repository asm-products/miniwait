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
  
   def show_error(exception)

     logthis(exception.message)
	 @errorMessage = exception.message
	 @stackTrace = exception.backtrace
	
	 # html page "show_error" displays error and offers login
	 render "show_error" and return
	
	 return
	
   end

   def feedback

      # populate user email if they are logged in (it's just polite)
      if session[:user_id]
         @person = Person.find(session[:user_id])
      else
         @person = Person.new
      end

      if request.post?
         if !params[:email].blank? && !params[:comment].blank?
            mailer = UserMailer.new()
            mailer.send_feedback(params[:email], params[:comment])
            flash[:user_message] = 'Thank you for your feedback.'
         else
            flash[:user_message] = 'Please enter an email address and your comment before submitting.'
         end
         render 'feedback'
      else
         # fall through to feedback form
      end
   end
  
end
