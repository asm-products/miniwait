class Person < ActiveRecord::Base
	has_many :locations, through: :favorites
	has_many :companies, through: :company_contacts
	
	
   def unique
      # Return true if this new person is unique by: username and email_address

 	  sql = "SELECT id FROM people WHERE username = ? OR email_address = ?;"
      found = Person.find_by_sql [sql, self.username, self.email_address]
	 
	  if found.blank?
	     return true # no conflict with any existing record
	  else
	     return (found[0].id == self.id) # no conflict if we found the record we started with
	  end
	 
   end

end
