class Location < ActiveRecord::Base
	belongs_to :company
	has_many :service_locations

   geocoded_by :full_address
   after_validation :geocode

end


def full_address
   [street1, street2, city, state_province, postal_code, country].compact.join(', ')
end