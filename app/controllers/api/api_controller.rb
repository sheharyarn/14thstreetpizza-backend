class Api::ApiController < ApplicationController
	require 'open-uri'
	require 'net/http'

	respond_to :json#, :xml


	def null
		respond_with nil
	end

	def get_token_data (token)
    	@uri  = URI.parse("https://graph.facebook.com/me/?fields=id,name&access_token=" + token)
	    @http = Net::HTTP.new(@uri.host, @uri.port)
	    @http.use_ssl = true
	    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	    @res = @http.get(@uri.request_uri)
	    @res = @res.body.to_s

	    if @res.split('error').count == 1
	      return JSON.parse @res
	    else
	      return nil
	    end
	end


	### APP TESTS
  	##########################
  	def test
  		tok = 'CAACijC3jCtEBACHztYKnyPRerLfpd8UPFTNgIK27IkTKpJXPCXPnZB51MzABZAP5JLqsZCjbjdbNeBltq6h6J80k7ZCpDgb9FL74EOS1C59uxJfRKc3wfKD3dTFole7NWFwz5snSqwKt4FcNcHZCiQgvAJ0LjLIzFeLGxjxb0fnFeo6hZANOjsILCsR0Fn44fZCk6SRVynAVAACuXbrY51E'
  		if get_token_data(tok).nil?
  			respond_with status: 'no'
		else
  			respond_with status: 'yes'
  		end

	end

	### REST TESTS
	##########################
	def uri_login;         return "http://localhost:3000/api/v1/me/login";                                      end
	def resp_login;        return RestClient.post uri_login, :fb_userid => '573655111', :fb_token => @fb_token; end
	
	def set_auth_token;    @auth_token = JSON.parse(resp_login)['auth_token'];                                  end
	def insert_token;      return '?auth_token=' + @auth_token + '&';                                           end

	def uri_me;            return "http://localhost:3000/api/v1/me" + insert_token;                             end
	def resp_me;           return JSON.parse(RestClient.get uri_me);                                            end

	def uri_logout;        return "http://localhost:3000/api/v1/me/logout" + insert_token;                      end
	def resp_logout;       return JSON.parse(RestClient.get uri_logout);                                        end
end
