class Api::V1::V1Controller < Api::ApiController

	def index
		respond_with valid: :true
	end

	def verify_user_token!
		if !user_signed_in?
			render_401 'auth_token missing or invalid'
		end
	end

	def render_400 (errors = 'required parameters invalid or not present')
    	@data = {
			status: 'failed',
			error:  errors
		}

		render json: @data, status: 400
  	end

  	def render_401 (errors = 'unauthorized access')
    	@data = {
			status: 'failed',
			error:  errors
		}

		render json: @data, status: 401
  	end

  	def render_404 (errors = 'not found')
    	@data = {
			status: 'failed',
			error:  errors
		}

		render json: @data, status: 404
  	end

  	def render_422 (errors = 'could not save data')
    	@data = {
			status: 'failed',
			error:  errors
		}

		render json: @data, status: 422
  	end
end
