class Company < ActiveRecord::Base
	has_many: locations
	has_many: services
	has_many: people,  through: :contacts
end
