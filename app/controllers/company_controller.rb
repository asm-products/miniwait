class CompanyController < ApplicationController
  def add
    check_authenticated(__method__) # error if user not logged in
    # fall through to view
    @company = Company.new
  end

  def create
    # Validate the incoming add form parameters and create new Company record
    # Company will be tied to the person that is logged in

    company = Company.new
    warning_messages = Array.new

    # name
    if params[:name].blank?
      warning_messages << 'Company name cannot be blank'
    else
      company.name = params[:name]
    end

    # category
    if params[:category_id].blank?
      warning_messages << 'Category cannot be blank'
    else
      company.category_id = params[:category_id]
    end

    if warning_messages.size == 0

      if company.unique
        begin
          if company.save
            # Also create a link between the logged in user and this company
            contact = CompanyContact.new
            contact.company_id = company.id
            contact.person_id = session[:user_id]
            contact.is_primary = true # first person to create a company becomes primary contact
            if !contact.save
              raise 'Failed to save CompanyContact record for new Company'
            end
          else
            logthis(company.errors.full_messages.join(';'))
          end
        rescue => e
          logthis("FAILED company.save: #{e.message} #{e.backtrace.join("\n")}")
        end
      else
        warning_messages << 'Company name already exists in this Category'
      end

    end

    if warning_messages.size == 0


      # Clear user errors
      flash[:user_message] = nil
      # Load company id for use by coming edit function
      session[:company_id] = company.id

      # Edit this company profile
      redirect_to :controller => 'company', :action => 'edit_profile'

    else

      # Load errors array into user message
      flash.now[:user_message] = warning_messages.join('; ')

      # Pass unsaved object back to edit form to preserve the user's work
      @company = company

      # Return to form and show errors
      render 'add'

    end

  end

  def edit_profile
    if session[:company_id].nil?
      raise 'Company edit_profile called without id'
    else
      @company = Company.find(session[:company_id])
    end
  end

  def update
    # Update existing company
    company = Company.find(session[:company_id])
    warning_messages = Array.new

    # name
    if params[:name].blank?
      warning_messages << 'Company name cannot be blank'
    else
      company.name = params[:name]
    end

    # category
    if params[:category_id].blank?
      warning_messages << 'Category cannot be blank'
    else
      company.category_id = params[:category_id]
    end

    if warning_messages.empty?

      if company.unique
        begin
          if !company.save
            logthis(company.errors.full_messages.join(';'))
          end
        rescue => e
          logthis("FAILED company.save: #{e.message} #{e.backtrace.join("\n")}")
        end
      else
        warning_messages << 'Company name already exists in this Category'
      end

    end

    if warning_messages.empty?


      # Clear user errors
      flash[:user_message] = nil
      # Load company id for use by coming edit function
      session[:company_id] = company.id

      # Edit this company profile
      redirect_to :controller => 'company', :action => 'edit_profile'

    else

      # Load errors array into user message
      flash.now[:user_message] = warning_messages.join('; ')

      # Pass unsaved object back to edit form to preserve the user's work
      @company = company

      # Return to form and show errors
      render 'edit_profile'

    end

  end

  def locations
  end

  def services
  end

  def location
  end
end
