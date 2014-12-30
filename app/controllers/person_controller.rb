class PersonController < ApplicationController

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
  end
  
end
