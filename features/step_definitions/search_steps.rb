Then /^I should see the cities for "([^\"]*)"$/ do |search_criteria|
  cities = CitySearch.find(search_criteria)
  cities.size.should == 2
  cities.each do |city|
    %{Then I should see "#{city.name}"}
  end
end

Then /^I should see the information for "([^\"]*)"$/ do |location_id|
  weather_man_response = WeatherMan.new(location_id).fetch
  weather = Weather.new(weather_man_response)
  %{Then I should see "#{weather.feels_like_in_farenheit}"}
  %{Then I should see "#{weather.wind_speed}"}
  %{Then I should see "#{weather.description}"}
  %{Then I should see "#{weather.pressure}"}
  %{Then I should see "#{weather.temperature}"}
  %{Then I should see "#{weather.sunrise_time}"}
end

Then /^I should see an error message$/ do
  page.should have_selector("div[class=error_message]")
end

Then /^I should not see an error message$/ do
  page.should_not have_selector("div[class=error_message]")
end

Given /^a search for "([^\"]*)" returns no results$/ do |arg1|
  class Weather
    def valid?
      false
    end
  end
end

