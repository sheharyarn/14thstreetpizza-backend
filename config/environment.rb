# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FourteenStreetPizza::Application.initialize!

## Custom String Methods for Controllers
class String
	def valid_integer?
    	!!Integer(self) rescue false
  	end

	def valid_float?
    	!!Float(self) rescue false
  	end
end