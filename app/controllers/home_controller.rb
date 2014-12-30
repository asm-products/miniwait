class HomeController < ApplicationController
	
  def index
	@person = Person.new
  end
  
  def signup
    # Validate the incoming signup form parameters and create new Person record
  
	person = Person.new
	warning_messages = Array.new
  
    # userName
	if params[:userName].blank?
	   warning_messages << "User name cannot be blank"
	else
	   person.username = params[:userName]
	end
	
    # password
	if params[:password].blank?
	   warning_messages << "Password cannot be blank"
	else
	   person.password = params[:password]
	   
	   # confirmPassword
	   if (params[:confirmPassword].blank? || params[:confirmPassword] != params[:password])
	      warning_messages << "Both passwords must match"
	   end	

   end


    # firstName
	if params[:firstName].blank?
	   warning_messages << "First name cannot be blank"
	else
	   person.first_name = params[:firstName]
	end

	# lastName
	if params[:lastName].blank?
	   warning_messages << "Last name cannot be blank"
	else
	   person.last_name = params[:lastName]
	end

    # emailAddress
	if (params[:emailAddress].blank? || (params[:emailAddress] !~ /^\S+@\S+\.\S+$/) )
	   warning_messages << "Email format is invalid"
	else
	   person.email_address = params[:emailAddress]
	end
	
	if warning_messages.size == 0

       if person.unique
          person.save		  
	   else
	      warning_messages << "User name or email has been used already"
	   end
	   
	end
	
	if warning_messages.size == 0
	
	      # Clear user errors
		  flash[:user_message] = nil
		  
		  # Pass username to edit function
		  session[:user_id] = person.id
		  
	      # Edit this user profile
          redirect_to :controller => 'person', :action => 'edit_profile'
		  
	else
	
		# Load errors array into user message
		flash[:user_message] = warning_messages.join("; ")
		
		# Pass person fields back to edit form to preserve the user's work
		@person = person
		
		# Return to form and show errors
		render "index"
	
    end
 
 end

  
  
end
