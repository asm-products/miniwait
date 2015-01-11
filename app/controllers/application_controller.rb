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
  
end
