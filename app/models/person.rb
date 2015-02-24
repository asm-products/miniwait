class Person < ActiveRecord::Base
   has_many :locations, through: :favorites
   has_many :company_contacts
   has_many :companies, through: :company_contacts

   validates_presence_of :username, :first_name, :last_name, :email_address

   geocoded_by :full_address
   after_validation :geocode

   require 'digest/sha2'


   def unique
      # Return true if this new person is unique by: username and email_address

      sql = 'SELECT id FROM people WHERE username = ? OR email_address = ?;'
      record_found = Person.find_by_sql [sql, self.username, self.email_address]

      if record_found.blank?
         true # no conflict with any existing record
      else
         (record_found[0].id == self.id) # no conflict if we found the record we started with
      end

   end

   def password=(user_password)
      # Save the password being assigned in encrypted form, plus the salt that generated it
      salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
      self.password_salt = salt
      self.password_hash = Digest::SHA256.hexdigest(user_password + salt)
   end

   def full_name
      self.first_name + ' ' + self.last_name
   end

   def sort_name
      self.last_name + ', ' + self.first_name
   end

   def full_address
      return self.street1 + ' ' + self.street2 + ', ' + self.city + ', ' + self.state_province + ' ' + self.postal_code + ' ' + self.country
   end
end

