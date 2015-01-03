require 'test_helper'

class PersonTest < ActiveSupport::TestCase

	test "save should fail without any fields" do
	  p = Person.new
	  assert_not p.save
	end
	
	test "save should work with all fields" do
	   p = Person.new
       p.username = "bsmith"
	   p.first_name = "Barbara"
	   p.last_name = "Smith"
	   p.email_address = "bsmith@nowhere.com"
	   p.street1 = "123 Main St."
	   p.street2 = "Apt D"
	   p.city = "Atlanta"
	   p.state_province = "GA"
	   p.postal_code = "30305"
	   p.country = "US"
	   p.phone_number = "770-555-1212"
       p.password = "test"	   
	   assert p.save
	end

end
