class ApplicationController < ActionController::Base
	protect_from_forgery

	# Custom String methods in config/environment.rb

	def comingsoon
    	render :template => '../../public/index.html', :layout => false, :status => 200
  	end

	def not_found
		if env["REQUEST_PATH"] =~ /^\/api/
			render :json => {:error => "not found"}.to_json, :status => 404
		else
			render :template => '../../public/404.html', :layout => false, :status => 404
		end
	end

	def exception
		if env["REQUEST_PATH"] =~ /^\/api/
			render :json => {:error => "internal server error"}.to_json, :status => 500
		else
			render :template => '../../public/500.html', :layout => false, :status => 500
		end
	end


	## MY CUSTOM METHOD TO CHECK IF A SIMILAR METHOD EXISTS FOR AN OBJECT
	## WRITTEN HERE SO I DON'T FORGET

  	def match_methods(methods, sample)
        methods.each do |m|
  	        if m.to_s.include? sample.to_s
                puts m
            end
        end

        return nil
    end	
end
