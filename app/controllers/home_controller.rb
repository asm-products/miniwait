class HomeController < ApplicationController

	def show
		@person = Person.new
	end


	def signup
		# Validate the incoming signup form parameters and create new Person record

		person = Person.new
		warning_messages = Array.new

		# userName
		if params[:userName].blank?
			warning_messages << 'User name cannot be blank'
		else
			person.username = params[:userName]
		end

		# password
		if params[:password].blank?
			warning_messages << 'Password cannot be blank'
		else

			msg = validate_password(params[:password])
			if msg != ""
				warning_messages << msg
			else
				person.password = params[:password]

				# confirmPassword
				if (params[:confirmPassword].blank? || params[:confirmPassword] != params[:password])
					warning_messages << 'Both passwords must match'
				end
			end

		end


		# firstName
		if params[:firstName].blank?
			warning_messages << 'First name cannot be blank'
		else
			person.first_name = params[:firstName]
		end

		# lastName
		if params[:lastName].blank?
			warning_messages << 'Last name cannot be blank'
		else
			person.last_name = params[:lastName]
		end

		# emailAddress
		if (params[:emailAddress].blank? || (params[:emailAddress] !~ /^\S+@\S+\.\S+$/) )
			warning_messages << 'Email format is invalid'
		else
			person.email_address = params[:emailAddress]
		end

		if warning_messages.empty?

			if person.unique
				begin
					if !person.save
						logthis(person.errors.full_messages.join(';'))
					end
				rescue => e
					logthis("FAILED person.save: #{e.message} #{e.backtrace.join("\n")}")
				end
			else
				warning_messages << 'User name or email has been used already'
			end

		end

		if warning_messages.empty?

			# Send welcome email
			mailer = UserMailer.new
			mailer.send_welcome_email(person)
			mailer = nil

			# Clear user errors
			flash[:user_message] = nil

			# Pass user to edit function
			session[:user_id] = person.id

			# Edit this user profile
			redirect_to :controller => 'person', :action => 'edit'

		else

			# Load errors array into user message
			flash.now[:user_message] = warning_messages.join("; ")

			# Pass unsaved person object back to edit form to preserve the user's work
			@person = person

			# Return to form and show errors
			render 'show'

		end

	end

end
