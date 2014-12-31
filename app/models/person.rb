class Person < ActiveRecord::Base
   has_many :locations, through: :favorites
   has_many :companies, through: :company_contacts

   require 'digest/sha2'	
	
   def unique
      # Return true if this new person is unique by: username and email_address

 	  sql = "SELECT id FROM people WHERE username = ? OR email_address = ?;"
      record_found = Person.find_by_sql [sql, self.username, self.email_address]
	 
	  if record_found.blank?
	     return true # no conflict with any existing record
	  else
	     return (record_found[0].id == self.id) # no conflict if we found the record we started with
	  end
	 
   end
   
   def password=(user_password)
      # Save the password being assigned in encrypted form, plus the salt that generated it
      salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
	  self.password_salt = salt
	  self.password_hash = Digest::SHA256.hexdigest(user_password + salt)
   end 
   
  def reset_password
    # Finish password recovery
	
	# Get reset token incoming url
	token = params[:prt]
	
	# Find user account by token
    person = Person.where(["password_reset_token = ?", token]).first
		 
	if person.nil?
	  raise 'Invalid password reset request!'
	else
	  session[:user_id] = person.id
	end
	
	# Offer password change page
    redirect_to :action => "change_password" and return
	
  end
  
  def change_password
    # Change my password
	
	if session[:user_id].nil?
	  raise 'Change password function is only available when logged in.'
	end

	# view 'change_password' is displayed to get the password inputs
  end
  
  def update_password
    # Save newly entered password
	
	pw1 = params[:password]
	pw2 = params[:password2]
	
	if pw1 != pw2
	  raise 'Password values do not match!'
	end
	
	@person = Person.find(session[:user_id])
	
	@person.password = pw1
	@person.save
		  
	flash[:user_message] = "Your password has been reset."
	
	redirect_to :action => 'dashboard' and return
	
  end
    
  def generate_token
    # Generate random token
	token = [Array.new(10){rand(256).chr}.join].pack("m").chomp
	token = Digest::SHA256.hexdigest(token)
	return token 
  end   

  
end
