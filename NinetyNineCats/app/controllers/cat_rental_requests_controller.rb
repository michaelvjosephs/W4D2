class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
    # fail
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    if @request.save
      redirect_to cats_url
    else
      @cats = Cat.all
      render :new
    end
  end

  def update
    @request = CatRentalRequest.find(params[:id])
    if params[:cat_rental_request][:status] == "APPROVE"
      new_status = "APPROVED"
    else
      new_status = "DENIED"
    end
    @request.update_attributes(status: new_status)
    # if @request.save
      redirect_to cat_url(@request.cat)
    # else

    # end
  end

  private
  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
