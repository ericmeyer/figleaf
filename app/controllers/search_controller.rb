class SearchController < ApplicationController
  def index
    @cities = CitySearch.find(params[:location])

    case @cities.size
    when 0
      flash[:errors] = "No Matching results were found."
      redirect_to(:controller => :home, :action => :index)
    when 1
      redirect_to(:controller => :weather, :action => :display, :id => @cities.first.id, :city_name => @cities.first.name)
    else
      flash.now[:errors]= "We found more than one city!"
      @homepage = true
      set_home_page_cities
      render :template => 'home/index'
    end
  end
end
