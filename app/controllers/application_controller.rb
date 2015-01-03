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
  
end
