class PostsController < ApplicationController
	def create
		if current_user
			@workout = Workout.find_by_sql(["SELECT CASE WHEN a.id IS NULL THEN FALSE ELSE TRUE END AS active, w.workout_type, e.id AS exercise_id, w.points_per_workout, w.duration,
			w.point_cutoffs, w.id AS workout_id FROM workouts w JOIN exercises e ON w.id = e.workout_id LEFT OUTER JOIN active_workouts a ON a.workout_id = w.id 
			WHERE w.id = ?", params[:id]]).first
			if @workout.workout_type == 3
				if params[:post][:seconds].present? || params[:post][:minutes].present?
					@vals = get_seconds(params[:post][:seconds], params[:post][:minutes])
					@post = Post.new(post_params.merge(user_id: current_user.id, active_workout: @workout.active, workout_id: params[:id], results_attributes: [has_points: true, reps: 1, exercise_id: @workout.exercise_id, total_points: @vals[1]]))
					@post.seconds = @vals[0]
				end
			else
				if @workout.workout_type == 1
					@post = Post.new(post_params.merge(user_id: current_user.id, active_workout: @workout.active, workout_id: params[:id], results_attributes: [has_points: true, reps: 1, exercise_id: @workout.exercise_id, total_points: @workout.points_per_workout]))
				else
					@post = Post.new(post_params.merge(user_id: current_user.id, active_workout: @workout.active, workout_id: params[:id]))
				end
				@post.seconds = @workout.duration * 60
			end
			if @post.save
				flash[:modal] = @post.id
				PostBadgeJob.perform_later(current_user.id)
			else
				flash[:alert] = "Error - " + @post.errors.full_messages[0]
			end
			redirect_to "/workouts/#{params[:id]}"
		end
	end
	def show
		if current_user
			@post = Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, posts.created_at, 
			posts.id, comment, name, email, image_path, rounds_and_reps,(SELECT SUM(total_points) FROM results WHERE results.post_id = ?) AS total_points, (SELECT COUNT(*) FROM likes 
			WHERE likes.thing_id = posts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) AS comment_count, workout_id, 
			points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users ON users.id = posts.user_id WHERE posts.id = ? 
			AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1)) LIMIT 1", params[:id], params[:id], current_user.id, current_user.id]).first
		else
			@post = Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, posts.created_at, 
			posts.id, comment, name, email, image_path, rounds_and_reps,(SELECT SUM(total_points) FROM results WHERE results.post_id = ?) AS total_points, (SELECT COUNT(*) FROM likes 
			WHERE likes.thing_id = posts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) AS comment_count, workout_id, 
			points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users ON users.id = posts.user_id WHERE posts.id = ? 
			AND users.privacy_setting = 0 LIMIT 1", params[:id], params[:id]]).first
		end
		@timestamp = Time.now.to_f
	end
	def edit
		@post = Post.where(id: params[:id], user_id: current_user.id).first if current_user
		@workout = Workout.find(@post.workout_id) if @post
	end
	def update
		@post = Post.where(id: params[:id], user_id: current_user.id).first if current_user
		if @post
			@workout = Workout.find(@post.workout_id)
			@post.remove_image! if @post.image? && params[:post][:image].blank? && params[:post][:delete_image]=="1"
			if @workout.workout_type == 3
				if params[:post][:seconds].present? || params[:post][:minutes].present?
					@vals = get_seconds(params[:post][:seconds], params[:post][:minutes])
					flash[:notice] = "Changes saved!" if @post.update_attributes(seconds: @vals[0], video_url: params[:post][:video_url], image: params[:post][:image], comment: params[:post][:comment], results_attributes: [id: @post.results.first.id, total_points: @vals[1]])
				end
			else
				if @workout.workout_type == 1
					flash[:notice] = "Changes saved!" if @post.update_attributes(video_url: params[:post][:video_url], image: params[:post][:image], comment: params[:post][:comment])
				else
					flash[:notice] = "Changes saved!" if @post.update_attributes(post_params)
				end
			end
		end
		flash[:alert] = "An error occurred. Try again later" unless flash[:notice].present?
		redirect_to "/posts/#{@post.id}"
	end
	def destroy
		@post = Post.find(params[:id])
		if current_user && @post.user_id == current_user.id
			if @post.destroy
				flash[:notice] = "Post deleted successfully."
				redirect_back fallback_location: "/weekly-workouts"
			else
				flash[:alert] = "Something went wrong. Please try again later."
				redirect_to "/posts/#{@post.id}"
			end
		end
	end

	private
	def post_params
		params.require(:post).permit(:video_url, :minutes, :seconds, :image, :delete_image, :comment, :results_attributes => [:reps, :exercise_id, :id])
	end
	def post_comment_params
		params.require(:post_comment).permit(:comment).merge(post_id: params[:id], user_id: current_user.id)
	end
	def get_seconds(secs, mins)
		@secs = secs.to_i
		@secs = (@secs + (mins.to_i * 60)) if mins.present?
		@c = @workout.point_cutoffs.split(":")
		@t = @c[0].split(",")
		@p = @c[1].split(",")
		@t.each_with_index do |t, i|
			if @secs < t.to_i
				@tp = @p[i]
				break
			end
		end
		@tp = @p.last unless @tp
		[@secs, @tp]
	end
end