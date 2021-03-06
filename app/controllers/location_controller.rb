class LocationController < ApplicationController
   def index
      @company = Company.find(params[:company_id])
   end

   def new
      check_authenticated(__method__) # error if user not logged in
      if current_user.my_company(params[:company_id])
         @location = Location.new
         @location.company_id = params[:company_id]
      else
         raise 'Location add called with unauthorized id.'
      end
   end

   def create
      # Validate the incoming form parameters and create new record

      location = Location.new
      location.company_id = params[:company_id]

      @company = Company.find(location.company_id)

      warning_messages = Array.new

      # LocName
      if params[:locName].blank?
         warning_messages << 'First name cannot be blank'
      else
         location.loc_name = params[:locName]
      end

      # street1
      if params[:street1].blank?
         warning_messages << 'Street 1 cannot be blank'
      else
         location.street1 = params[:street1]
      end

      # street2
      location.street2 = params[:street2]

      # city
      if params[:city].blank?
         warning_messages << 'City cannot be blank'
      else
         location.city = params[:city]
      end

      # state province
      if params[:stateProvince].blank?
         warning_messages << 'State/Province cannot be blank'
      else
         location.state_province = params[:stateProvince]
      end

      # postal code
      if params[:postalCode].blank?
         warning_messages << 'Zip/Postal cannot be blank'
      else
         location.postal_code = params[:postalCode]
      end

      # country
      if params[:country].blank?
         warning_messages << 'Country cannot be blank'
      else
         location.country = params[:country]
      end

      # phone number
      if params[:phoneNumber].blank?
         warning_messages << 'Phone number cannot be blank'
      else
         location.phone_number = params[:phoneNumber]
      end

      if warning_messages.empty?

         location.save

         # Clear user errors
         flash[:user_message] = nil

         render 'index'

      else

         # Load errors array into user message
         flash.now[:user_message] = warning_messages.join("; ")

         # Pass unsaved object back to edit form to preserve the user's work
         @location = location

         # Return to form and show errors
         render 'new'

      end

   end

   def show
      # Display one company location to allow adjustment of service wait times (for company staff)
      @location = Location.find(params[:id])
      if current_user.my_company(@location.company_id)
         @company = Company.find(@location.company_id)
         @location_services = @location.service_locations.order(service_id: :asc)
      else
         raise 'Location show called with unauthorized id.'
      end

   end

   def view
      # Display one company location with service wait times (for consumer)
      @location = Location.find(params[:id])
      @company = Company.find(@location.company_id)

      # Return location services, adding whether this person is 'watching' a service
      sql = "SELECT sl.id, sl.location_id, sl.service_id, sl.wait_time, COALESCE(sw.person_id,0) AS watching"
      sql += " FROM service_locations sl"
      sql += " LEFT JOIN service_watches AS sw ON sl.id = sw.service_location_id AND sw.person_id = #{current_user.id}"
      sql += " WHERE location_id = #{@location.id}"
      sql += " ORDER BY sl.service_id"
      @location_services = ServiceLocation.find_by_sql(sql)

   end

   def watch
      # Add this location service to consumer watch list
      @service_loc = ServiceLocation.find(params[:id])

      if @service_loc
         ServiceWatch.create(service_location_id: @service_loc.id, person_id: current_user.id)
      end

      redirect_to :controller => 'location', :action => 'view', :id => @service_loc.location.id
   end

   def unwatch
      # Remove this location service from consumer watch list
      @service_loc = ServiceLocation.find(params[:id])

      if @service_loc
         ServiceWatch.destroy_all(:service_location_id => @service_loc.id, :person_id => current_user.id)
      end

      redirect_to :controller => 'location', :action => 'view', :id => @service_loc.location.id

   end

   def edit
      check_authenticated(__method__) # error if user not logged in
      # Edit one company location
      @location = Location.find(params[:id])
      if current_user.my_company(@location.company_id)
         @company = Company.find(@location.company_id)
         @location_services = @location.service_locations
         @company_services = @company.services
      else
         raise 'Location edit called with unauthorized id.'
      end
   end

   def update
      # Validate the incoming form parameters and update record

      location = Location.find(params[:id])

      warning_messages = Array.new

      # LocName
      if params[:locName].blank?
         warning_messages << 'First name cannot be blank'
      else
         location.loc_name = params[:locName]
      end

      # street1
      if params[:street1].blank?
         warning_messages << 'Street 1 cannot be blank'
      else
         location.street1 = params[:street1]
      end

      # street2
      location.street2 = params[:street2]

      # city
      if params[:city].blank?
         warning_messages << 'City cannot be blank'
      else
         location.city = params[:city]
      end

      # state province
      if params[:stateProvince].blank?
         warning_messages << 'State/Province cannot be blank'
      else
         location.state_province = params[:stateProvince]
      end

      # postal code
      if params[:postalCode].blank?
         warning_messages << 'Zip/Postal cannot be blank'
      else
         location.postal_code = params[:postalCode]
      end

      # country
      if params[:country].blank?
         warning_messages << 'Country cannot be blank'
      else
         location.country = params[:country]
      end

      # phone number
      if params[:phoneNumber].blank?
         warning_messages << 'Phone number cannot be blank'
      else
         location.phone_number = params[:phoneNumber]
      end

      if warning_messages.empty?

         location.save

         # Clear user errors
         flash[:user_message] = nil

         @company = Company.find(location.company_id)

         render 'index'

      else

         # Load errors array into user message
         flash.now[:user_message] = warning_messages.join("; ")

         # Pass unsaved object back to edit form to preserve the user's work
         @location = location

         # Return to form and show errors
         render 'new'

      end

   end

   def add_service
      check_authenticated(__method__) # error if user not logged in
      # Add one service to one location
      service_id = params[:svc]
      location_id = params[:loc]
      sql = 'SELECT id FROM service_locations WHERE service_id = ' + service_id + ' AND location_id = ' + location_id
      sloc = ServiceLocation.find_by_sql(sql).first
      if sloc.blank?
         @location = Location.find(location_id)
         @location.service_locations.create(:location_id => location_id, :service_id => service_id, :wait_time => 0)
      end
      redirect_to :controller => 'location', :action => 'edit', :id => location_id
   end

   def remove_service
      check_authenticated(__method__) # error if user not logged in
      # Remove one service from one location
      service_id = params[:svc]
      location_id = params[:loc]
      sql = 'SELECT id FROM service_locations WHERE service_id = ' + service_id + ' AND location_id = ' + location_id
      sloc = ServiceLocation.find_by_sql(sql).first
      if !sloc.blank?
         sloc.destroy()
      end
      redirect_to :controller => 'location', :action => 'edit', :id => location_id
   end

   def update_wait_time
      check_authenticated(__method__) # error if user not logged in
      sloc_id = params[:id]
      change_val = params[:change_val]
      if (!change_val.blank? && !sloc_id.blank?)
         sloc = ServiceLocation.find(params[:id])
         new_time = sloc.wait_time + change_val.to_i
         if new_time >= 0
            sloc.wait_time = new_time
            sloc.save
         end
         redirect_to :controller => 'location', :action => 'show', :id => sloc.location_id
      end
   end

   def destroy
   end

   def search
      # Search for businesses of interest that are nearby
      # params: name, category_id, near (zip), distance

      # Load the logged in user to start with their location (zip)
      @person = current_user

      if request.post?
         @criteria = params.dup
         addr = @criteria[:near]
         max_distance = @criteria[:distance]

         locs = Location.near(addr, max_distance).order('distance')
         @results = Array.new
         locs.each do |loc|
            wanted = true
            if (@criteria[:name].present? && !(loc.company.name.downcase.include? @criteria[:name].downcase))
               wanted = false
            end
            if (@criteria[:category_id].present? && loc.company.category_id != @criteria[:category_id].to_i)
               wanted = false
            end
            if wanted
               res = { :id => loc.id, :company_name => loc.company.name, :loc_name => loc.loc_name, :category_description => loc.company.category.description,
                       :address => loc.street1 + ', ' + loc.city, :distance => loc.distance.round(2) }
               @results << res
            end

         end
      else
         @criteria = {}
         @criteria[:distance] = 10 # miles
         @criteria[:near] = @person.full_address
         @results = []
      end
   end

end

