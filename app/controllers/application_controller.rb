class ApplicationController < ActionController::Base

   def logthis(msg)
      logger.debug "===================================="
      logger.debug msg
      logger.debug "===================================="
   end
end
