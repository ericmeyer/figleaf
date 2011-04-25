require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "home/index.html.haml" do
  before(:each) do
    assign(:home_page_cities, [])
  end
  
  it "should have an input for the location on index" do
    render
    
    rendered.should have_selector("form[action='/search']")
    rendered.should have_selector("input[type=text][name=location]")
    rendered.should have_selector("input[type=submit][value=search]")
  end
  
  it "should show city names" do
    # <a href="/blah?id=IAIAIA">Name</a>
    value = rand 1000
    assign(:cities, [mock("weather man 1", :name => "London #{value}", :id => "#{value}L"), 
                     mock("weather man 2", :name => "Chicago", :id => "#{value}C")])
    
    render :template => "home/index"
    
    rendered.should include("London #{value}")
    rendered.should include("Chicago")
    rendered.should have_selector("a[href='/weather/display/#{value}L?city_name=London+#{value}']")
  end
  
  it "should pass the city names in the link" do
    # <a href="/blah?id=IAIAIA">Name</a>
    value = rand 1000
    assign(:cities, [mock("weather man 1", :name => "London #{value}", :id => "#{value}L"), 
                      mock("weather man 2", :name => "Chicago", :id => "#{value}C")])
    
    render :template => "home/index"
    
    rendered.should =~ /London #{value}/
    rendered.should include("Chicago")
    rendered.should have_selector("a[href='/weather/display/#{value}L?city_name=London+#{value}']")
  end
  
  it "should show an error div" do
    flash[:errors] = "error message"
    
    render :template => "home/index"
    
    rendered.should have_selector("div[class=error_message]")
    rendered.should include("error message")
  end
  
  it "should not show an error div if the flash errors is not set" do
    flash[:errors] = nil
    
    render :template => "home/index"
    
    rendered.should_not have_selector("div[class=error_message]")
  end
end