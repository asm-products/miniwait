class ServiceController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
  end

  def create
    # Add service to this company
    d = params[:description]
    if d.blank?
      flash[:user_message] = 'Service name cannot be blank'
    else
      @company = Company.find(params[:company_id])

      # Primary flag is automatically set on the first service created but can be changed later
      pri = (@company.services.count == 0)

      # Create the new service for this company
      @company.services.create(:company_id => params[:company_id], :description => d, :is_primary => pri)
    end
    render 'index'
  end

  def destroy
	  # Delete one service from this company
    if !params[:id].blank?
       @service = Service.find(params[:id])
       @company = Company.find(@service.company.id)
       @service.destroy
    end
    # Clean out linked services from all locations
    sql = 'SELECT id FROM service_locations WHERE service_id = ' + @service.id.to_s
    slocs = ServiceLocation.find_by_sql(sql)
    slocs.each do |sloc|
	    sloc.destroy()
    end
    render 'index'
  end
end
