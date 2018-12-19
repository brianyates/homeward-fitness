class WorkoutsController < ApplicationController
	def create
		if is_admin?
			@workout = Workout.new(workout_params)
			if @workout.save
				flash[:notice] = "Workout created!"
				redirect_to "/workouts/#{@workout.id}"
			else
				flash[:alert] = "Error - " + @workout.errors.full_messages[0]
				redirect_to "/workouts/new"
			end
		end
	end
	def update
		if is_admin?
			@workout = Workout.find(params[:id])
			if @workout.update_attributes(workout_params)
				flash[:notice] = "Workout updated successfully!"
				redirect_to "/workouts/#{@workout.id}"
			else
				flash[:alert] = "Error - " + @workout.errors.full_messages[0]
				redirect_to "/workouts/#{@workout.id}/edit"
			end
		end
	end
	def new
		@workout = Workout.new
		@instructors = Instructor.all.select(:id, :instructor_name).map {|i| [i.instructor_name, i.id]}
		@workout_types = workout_types.map { |key, value| [value, key] }
	end
	def current
		@workouts = current_workouts
		@active_cutoff = active_cutoff.in_time_zone('EST').strftime('%B %d, %Y')
		@workout_count = @workouts.length
	end
	def index
		@workouts = Workout.joins("JOIN instructors ON instructors.id = workouts.instructor_id").where(active_flag: true).select(:video_url, :image, :instructor_id, 
		"workouts.id AS id", :instructor_name, :website_url, :duration, :workout_title, :workout_description, :difficulty, :required_equipment, :updated_at, :workout_type, 
		:point_cutoffs, :points_per_workout, :created_at).order(:created_at).limit(12)
		@workout_count = @workouts.length
	end
	def edit
		@workout = Workout.find(params[:id])
		@instructors = Instructor.all.select(:id, :instructor_name).map {|i| [i.instructor_name, i.id]}
		@workout_types = workout_types.map { |key, value| [value, key] }
	end
	def edit_active
		@active_workouts = ActiveWorkout.joins("JOIN workouts ON workouts.id = active_workouts.workout_id").select(:id, :workout_id, 
		:workout_title, :workout_description).order(:id)
		@workouts = Workout.all.select(:id, :workout_title).map {|i| [i.id.to_s + " - " + i.workout_title, i.id]}
	end
	def update_active
		if is_admin?
			LeaderboardNotificationJob.perform_now if params[:active][:run_leaderboard_job] == "1"
			@params = params.require(:active).permit("1", "2", "3", "4", "5", "6").to_h
			@error = false
			@params.each do |key, val|
				@a = ActiveWorkout.find(key)
				if @a.update_attributes(workout_id: val)
					if Workout.find(val).update_attributes(active_flag: true)
					else
						@error = true
						flash[:alert] = "An error occurred - changes were not saved!"
					end
				else
					@error = true
					flash[:alert] = "An error occurred - changes were not saved!"
				end
			end
			flash[:notice] = "Active Workout changes saved successfully!" unless @error
			redirect_to "/active-workouts"
		end
	end
	def show
		@workout = Workout.where(id: params[:id]).joins("JOIN instructors ON instructors.id = workouts.instructor_id").select("workouts.*, (SELECT COUNT(*) FROM likes WHERE 
		likes.thing_id = workouts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = workouts.thing_id) AS comment_count, 
		instructors.instructor_name, instructors.id AS instructor_id").first
		@timestamp = Time.now.to_f
		@comments = get_comments(@workout.thing_id, @timestamp, 0) if @workout
		@active_id = ActiveWorkout.where(workout_id: @workout.id).select(:id).first if @workout
		@active_id.present? ? (@workout_title = "Weekly Workout #{@active_id.id} - #{@workout.workout_title}") : (@workout_title = @workout.workout_title)
		@post = Post.new
	end
	def destroy
		if is_admin?
			@workout = Workout.find(params[:id])
			if @workout.destroy
				flash[:notice] = "Workout deleted"
				redirect_to "/weekly-workouts"
			else
				flash[:alert] = "An error occurred."
				redirect_to "/workouts/#{@workout.id}/edit"
			end
		end
	end
	def main_menu_workouts
		@workouts = current_workouts
		respond_to do |format|
			format.html
			format.js
		end
	end
	def top_menu_workouts
		@workouts = current_workouts
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	private
	def workout_params
		params.require(:workout).permit(:workout_title, :workout_description, :video_url, :workout_type, :active_flag, :instructor_id, :duration, :difficulty, :required_equipment, 
		:point_cutoffs, :points_per_workout, :custom_note, :image, :rounds_and_reps, :exercises_attributes => [:exercise_description, :points_per_rep, :id, :reps_per_round])
	end
end