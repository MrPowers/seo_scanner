class WebpageAssessorsController < ApplicationController

  def new
    @webpage_accessor = WebpageAssessor.new
  end

  def create
    @webpage_accessor = WebpageAssessor.new(webpage_assessor_params)
    if @webpage_accessor.save
      redirect_to @webpage_accessor
    else
      redirect_to new_webpage_assessor_path
    end
  end

  def show
    @webpage_accessor = WebpageAssessor.find(params[:id])
  end

  def webpage_assessor_params
    params.require(:webpage_assessor).permit(:email, :url)
  end

end
