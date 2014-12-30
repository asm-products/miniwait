module ApplicationHelper

   def show_error(exception)

    logmsg(exception.message)
	@errorMessage = exception.message
	@stackTrace = exception.backtrace
	
	# html page "show_error" displays error and offers login
	render "show_error" and return
	
	return
	
  end
  
  def logthis(msg)
    # write debug message with box that is easy to find
    logger.debug "\n*****************************************\n"
	logger.debug "\n#{msg}\n"
    logger.debug "\n*****************************************\n"
  end
  
 
end
