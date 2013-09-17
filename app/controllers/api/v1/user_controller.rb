class Api::V1::UserController < Api::V1::V1Controller
	before_filter :verify_user_token!, :except => [:login, :validsession]

	def index
		@user = current_user

		respond_with(
			status: 'successful',
			user: {
				name: @user.fb_name,
				fbid: @user.fb_userid
			}
		)
	end

	def coordinates
		if params[:coordinates].present? && params[:coordinates].to_s.split(',').count == 2
			@coordinates = params[:coordinates].to_s.split(',')
			
			if @coordinates[0].valid_float? && @coordinates[1].valid_float?
				@user = current_user
				@coordinates = [@coordinates[0].to_f.to_s, @coordinates[1].to_f.to_s]
				@user.coordinates = @coordinates

				if @user.save
					render json: {
						status: 'successful',
						coordinates: @coordinates.join(', ')
					}
				else
					render_422 @user.errors.full_messages.as_json
				end
			else
				render_400
			end
		else
			render_400
		end
	end

	def login
		if params[:fb_token].present? && params[:fb_userid].present?
			@fbdata = get_token_data(params[:fb_token])

			if @fbdata.nil?
				render_400 'facebook token invalid'
			elsif @fbdata['id'] != params[:fb_userid]
				render_401 'facebook token does not belong to specified user'
			else
				@user = User.where(:fb_userid => params[:fb_userid])

				if @user.count == 0
					@newuser = true
					@user = User.new(
						:fb_userid => @fbdata['id'],
						:fb_name   => @fbdata['name'],
						:fb_token  => params[:fb_token]
					)
				else
					@newuser = false	
					@user = @user[0]
					@user.fb_name  = @fbdata['name']
					@user.fb_token = params[:fb_token]
				end

				if @user.save
					@user.reset_authentication_token!
					sign_in :user, @user
					render json: {
						status: 'successful',
						auth_token: current_user.authentication_token,
						new_user: @newuser.to_s
					}
				else
					render_422 'could not log in'
				end
			end
		else
			render_400
		end
	end

	def logout
        if user_signed_in?
            current_user.authentication_token=nil
            current_user.save
            sign_out current_user
			respond_with status: 'successful'
        else
			respond_with status: 'failed',
						 error:  'user not signed in'
        end
	end

	def validsession
		if user_signed_in?
			respond_with valid: :true
		else
			respond_with valid: :false
		end
	end
end