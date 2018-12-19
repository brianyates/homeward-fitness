class InstructorsController < ApplicationController
	def index
		@instructors = Instructor.find_by_sql("SELECT i.*, (SELECT COUNT(*) FROM workouts WHERE workouts.instructor_id = i.id) AS workout_count FROM instructors i ORDER BY workout_count DESC")
	end
	
	def new
		@instructor = Instructor.new
	end
	
	def show
		@instructor = instructor_info
		@owner = (current_user && current_user.instructor_id == params[:id].to_i)
		@workouts = Workout.where(instructor_id: params[:id])
	end
	
	def show_owner
		if current_user && current_user.instructor_id == params[:id].to_i
			@instructor = instructor_info
			@workouts = Workout.where(instructor_id: params[:id]).order(created_at: :DESC)
			@avatar = Avatar.where(instructor_id: current_user.instructor_id).last
		end
	end
	
	def get_instructor_map
		@instructor = Instructor.where(id: params[:id]).select(:address, :longitude, :latitude).first
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	
	def edit
		if current_user && current_user.instructor_id == params[:id].to_i
			@instructor = Instructor.find(params[:id])
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def update
		if current_user && current_user.instructor_id == params[:id].to_i
			@instructor = Instructor.find(params[:id])
			if @instructor.update_attributes(instructor_params)
				respond_to do |format|
					format.html
					format.js
				end
			else
				flash[:alert] = "Error - " + @instructor.errors.full_messages[0]
				redirect_to "/instructors/#{params[:id]}/owner"
			end
		end
	end
	def create
		@instructor = Instructor.new(instructor_params)
		if @instructor.save
			flash[:notice] = "Instructor created successfully!"
		else
			flash[:alert] = "Error - " + @instructor.errors.full_messages[0]
		end
		redirect_to "/instructors/#{@instructor.id}"
	end
	
	def change_view
		if params[:view][:option] == "1"
			redirect_to("/instructors/#{params[:id]}/owner", turbolinks: false)
		else
			redirect_to("/instructors/#{params[:id]}", turbolinks: false)
		end
	end
	
	def new_invite
		@instructor_token = InstructorToken.new if is_admin?
		@instructors = Instructor.all.select(:id, :instructor_name).map {|i| [i.instructor_name, i.id]}
	end
	def create_invite
		if is_admin?
			@user = User.find_by_email(params[:instructor_token][:email])
			if @user
				@token = rand(36**72).to_s(36)
				@instructor_token = InstructorToken.new(invite_params.merge(password: @token, user_id: @user.id))
				if @instructor_token.save
					@instructor = Instructor.find(@instructor_token.instructor_id)
					MainMailer.invite_owner(@user, @instructor, @instructor_token.id, @token).deliver_now
					flash[:notice] = "Invitation sent!"
				else
					flash[:alert] = "Error - " + @instructor_token.errors.full_messages[0]
				end
			else
				flash[:alert] = "There is no account associated with this email."
			end
			redirect_to "/invite-owner"
		end
	end
	
	def accept_invitation
		@t = InstructorToken.where(user_id: params[:uid], id: params[:tid], instructor_id: params[:iid]).first
		if @t && @t.authenticate(params[:token])
			@user = User.find_by_id(params[:uid])
			if @user && @user.update_attributes(instructor_id: params[:iid])
				InstructorToken.where(user_id: params[:uid]).destroy_all
				flash[:notice] = "Invitation accepted!"
				redirect_to "/instructors/#{params[:iid]}"
			else
				flash[:alert] = "Error - " + @user.errors.full_messages[0] if @user
				redirect_to "/weekly-workouts"
			end
		else
			flash[:alert] = "You have used an expired or invalid token"
			redirect_to "/weekly-workouts"
		end
	end
	
	private
	def instructor_params
		params.require(:instructor).permit(:website_url, :instructor_name, :about_me, :address, :image_path)
	end
	def instructor_info
		Instructor.find_by_sql(["SELECT i.instructor_name, i.created_at, i.website_url, i.about_me, i.image_path, (SELECT COUNT(*) FROM workouts WHERE workouts.instructor_id = ?) AS
		workout_count FROM instructors i WHERE i.id = ?", params[:id], params[:id]]).first
	end
	def invite_params
		params.require(:instructor_token).permit(:instructor_id, :email)
	end
end