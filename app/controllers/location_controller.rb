class LocationController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
  end

  def new
    @location = Location.new
    @location.company_id = params[:company_id]
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
  end

  def edit
    @location = Location.find(params[:id])
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

  def destroy
  end
end
