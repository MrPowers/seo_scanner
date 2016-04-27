class WebpageAssessorsController < ApplicationController

  def new
    @webpage_accessor = WebpageAssessor.new
  end

  def create
    @webpage_accessor = WebpageAssessor.new(webpage_assessor_params)
    if @webpage_accessor.save
      flash[:success] = 'We will send you an email shortly!'
      redirect_to @webpage_accessor
    else
      render :new
    end
  end

  def show
    @webpage_accessor = WebpageAssessor.find(params[:id])
    @url_evaluator = UrlEvaluator.new(url: @webpage_accessor.url)
  end

  def webpage_assessor_params
    params.require(:webpage_assessor).permit(:email, :url)
  end

end
