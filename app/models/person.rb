class Person < ActiveRecord::Base
	has_many: locations, through: :favorites
	has_many: companies, through: :company_contacts
end
