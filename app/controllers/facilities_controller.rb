class FacilitiesController < ApplicationController

  before_filter :authenticate_user!
  def index
    @facility = Facility.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @facility }
    end
  end

  def show
    @facility = Facility.find(facility_params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @facility }
    end
  end

  def new
    @facility = Facility.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @facility }
    end
  end

  def edit
    @facility = Facility.find(facility_params[:id])
  end

  def create
    @facility = Facility.new(facility_params[:facility])

    respond_to do |format|
      if @facility.save
        format.html { redirect_to @facility, notice: 'Facility was successfully created.' }
        format.json { render json: @facility, status: :created, location: @facility }
      else
        format.html { render action: "new" }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @facility = Facility.find(facility_params[:id])

    respond_to do |format|
      if @facility.update_attributes(facility_params[:facility])
        format.html { redirect_to @facility, notice: 'Facility was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facility = Facility.find(facility_params[:id])
    @facility.destroy

    respond_to do |format|
      format.html { redirect_to organization_path(current_user.organization.slug), notice: "Facility was sucessfully destroyed."  }
      format.json { head :no_content }
    end
  end

  protected

  def facility_params
    Facility.permitted(params).merge(params.permit(:id))
  end
end
