class ServiceWatch < ActiveRecord::Base
	belongs_to :person
	belongs_to :service_location
end
