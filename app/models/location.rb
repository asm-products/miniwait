class Location < ActiveRecord::Base
	belongs_to :company
	has_many :service_locations

   geocoded_by :full_address
   after_validation :geocode

end


def full_address
   return self.street1 + ' ' + self.street2 + ', ' + self.city + ', ' + self.state_province + ' ' + self.postal_code + ' ' + self.country
end