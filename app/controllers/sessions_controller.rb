class SessionsController < ApplicationController

	def new
		if current_user
			redirect_to "/users/#{current_user.id}"
		else
			@user = User.new
		end
	end

	def create
		@user = User.find_by_email(params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			flash[:notice] = "Welcome, #{@user.name.split(" ")[0]}!"
			redirect_back fallback_location: "/weekly-workouts"
		else
			@error = true
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def create_sync
		@user = User.find_by_email(params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			flash[:notice] = "Welcome, #{@user.name.split(" ")[0]}!"
			redirect_to "/users/#{@user.id}", turbolinks: false
		else
			flash[:alert] = "Invalid email or password"
			redirect_to "/login"
		end
	end
	
	def create_from_omniauth
		@user = User.from_omniauth(request.env["omniauth.auth"])
		if @user.errors.any?
			flash[:alert] = "Error - " + @user.errors.full_messages[0]
		else
			session[:user_id] = @user.id
			flash[:notice] = "Welcome, #{@user.name.split(" ")[0]}!"
		end
		@redirect_path = request.env["omniauth.params"]["redirect_to"] || "/weekly-workouts"
		redirect_to @redirect_path
	end
	
	def destroy 
		session[:user_id] = nil
		flash[:notice] = "Logged out successfully."
		redirect_back fallback_location: "/weekly-workouts"
	end
end
