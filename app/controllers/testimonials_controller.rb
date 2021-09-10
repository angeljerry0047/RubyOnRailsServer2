class TestimonialsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @testimonials = Testimonial.all

    respond_to do |format|
      format.html
      format.json { render json: @testimonials }
    end
  end

  def show
    @testimonial = Testimonial.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @testimonial }
    end
  end

  def new
    @testimonial = Testimonial.new
    @opportunity = Opportunity.find(flash[:opportunity_id])

    respond_to do |format|
      format.html
      format.json { render json: @testimonial }
    end
  end

  def edit
    @testimonial = Testimonial.find(params[:id])
  end

  def approve
    @testimonial = Testimonial.find(params[:id])

    if params[:event] == 'accepted'
      @testimonial.update_attributes(approved: true)
      redirect_to user_path(current_user), :notice => "Successfully Posted Testimonial"
    end

  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])
    @testimonial.creator_id = current_user.id

    respond_to do |format|
      if @testimonial.save
        Notifier.new_testimonial_email(@testimonial).deliver_now!
        format.html { redirect_to skills_path, notice: 'Testimonial was successfully created.' }
        format.json { render json: @testimonial, status: :created, location: @testimonial }
      else
        format.html { render action: "new" }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @testimonial = Testimonial.find(params[:id])

    respond_to do |format|
      if @testimonial.update_attributes(params[:testimonial])
        format.html { redirect_to user_path(current_user.id), notice: 'Testimonial was posted' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy

    respond_to do |format|
      format.html { redirect_to testimonials_url }
      format.json { head :no_content }
    end
  end

  protected

  def testimonials_params
    Testimonial.permitted(params).merge(params.permit(:id, :opportunity_id))
  end

end
