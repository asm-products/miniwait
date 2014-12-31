class PersonController < ApplicationController
  
   def login
     #show the default view
   end
  
   def logout
      session[:user_id] = nil
	  flash[:user_message] = "You have been logged out."
	  redirect_to :controller => "person", :action => "login"
   end  
 
   def authenticate
      # process the login form post and capture the logged in user if successful
	 
      person = Person.where(["username = ?", params[:username]]).first 
	 
	  if !person.blank? && (Digest::SHA256.hexdigest(params[:password] + person.password_salt) == person.password_hash)		
	     session[:user_id] = person.id
		 redirect_to :action => "dashboard"
      else
	     flash.now[:user_message] = "Invalid user name or password entered."
		 render "login"
	  end
	 
   end
  
   def forgot_password
      if request.post?
	     # Lookup username OR email_address. Finding either, send password reset link.
		 person = Person.where(["username = ? OR email_address = ?", params[:username], params[:email_address]]).first

         if person.blank?
	        flash.now[:user_message] = "Sorry, we cannot find that user name or email address."
         else		 
		 
			 # Send welcome email
			 mailer = UserMailer.new
			 mailer.send_password_reset_email(person)
			 mailer = nil

			 # Tell the user what we did
			 flash[:user_message] = "We just emailed you a password reset link. Please check your email."
			 
		 end 
	  end
      # Fall through to display the form
   end
   
   def change_password
   end
   
   def reset_password
      # This is where the email link comes, containing the unique reset hash to lookup
   end
  
  def edit_profile
     # Load person from session user id
	 @person = Person.find(session[:user_id]) 
  end
  
  def save_profile
     # Save an edited profile, checking rules

    @person = Person.find(session[:user_id]) 

	warning_messages = Array.new
  
    # userName
	if params[:userName].blank?
	   warning_messages << "User name cannot be blank"
	else
	   @person.username = params[:userName]
	end


    # firstName
	if params[:firstName].blank?
	   warning_messages << "First name cannot be blank"
	else
	   @person.first_name = params[:firstName]
	end

	# lastName
	if params[:lastName].blank?
	   warning_messages << "Last name cannot be blank"
	else
	   @person.last_name = params[:lastName]
	end

    # emailAddress
	if (params[:emailAddress].blank? || (params[:emailAddress] !~ /^\S+@\S+\.\S+$/) )
	   warning_messages << "Email format is invalid"
	else
	   @person.email_address = params[:emailAddress]
	end

	# phoneNumber
	if params[:phoneNumber].blank?
	   warning_messages << "Phone number cannot be blank"
	else
	   @person.phone_number = params[:phoneNumber]
	end

	# street1
	if params[:street1].blank?
	   warning_messages << "Street 1 cannot be blank"
	else
	   @person.street1 = params[:street1]
	end

	# street2 (optional)
    @person.street2 = params[:street2]

	# stateProvince
	if params[:stateProvince].blank?
	   warning_messages << "State cannot be blank"
	else
	   @person.state_province = params[:stateProvince]
	end	

	# postalCode
	if params[:postalCode].blank?
	   warning_messages << "Zip/Postal code cannot be blank"
	else
	   @person.postal_code = params[:postalCode]
	end

	# country
	if params[:country].blank?
	   warning_messages << "Country cannot be blank"
	else
	   @person.country = params[:country]
	end
	
	if warning_messages.size == 0

       if @person.unique	
          @person.save		  
	   else
	      warning_messages << "User name or email has been used already"
	   end
	   
	end
	
	if warning_messages.size == 0
	
	      # Clear user errors
		  flash[:user_message] = 'Profile updated'

		  redirect_to :action => "dashboard"
		  
	else
	
		# Load errors array into user message
		flash.now[:user_message] = warning_messages.join("; ")
		
		render "edit_profile"
			
    end

  end
  
  def dashboard
     if session[:user_id].nil?
        flash[:user_message] = 'Dashboard only available when logged in.'
		redirect_to :controller => 'person', :action => 'login'
	 else
	    @person = Person.find(session[:user_id])
	 end
  end
  
end
