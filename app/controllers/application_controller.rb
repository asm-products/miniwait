class ApplicationController < ActionController::Base

   # General trap for unhandled errors
   rescue_from Exception::StandardError, with: :handle_error

   def handle_error
      if $!
         show_error($!)
      end
   end

   def current_user
      return unless session[:user_id]
      @current_user ||= Person.find(session[:user_id])
   end

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
     if current_user.nil?
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
      if current_user
         @person = current_user
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

   def test_error
      # For testing unhandled errors
      x = 1/0
   end


end
