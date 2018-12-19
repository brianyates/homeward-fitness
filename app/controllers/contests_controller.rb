class ContestsController < ApplicationController
	def new
		@contest = Contest.new
	end
	def create
		if current_user
			@contest = Contest.new(contest_params.merge(owner_id: current_user.id))
			if @contest.save
				BadgeCreationJob.perform_later(current_user.id, 17)
				flash[:notice] = "Contest created!"
				redirect_to "/contests/#{@contest.id}"
			else
				flash[:alert] = "Error - " + @contest.errors.full_messages[0]
				redirect_to "/contests/new"
			end
		end
	end
	
	def show
		@contest = Contest.find_by_sql(["SELECT contests.* FROM contests JOIN contestants ON contests.id = contestants.contest_id WHERE contestants.status = 2 AND contestants.user_id = ? AND contests.id = ?", current_user.id, params[:contest_id]]).first if current_user
		if @contest
			@ts = Time.now
			@top_performers = top_performers(@contest.start_date, @contest.end_date, @contest.id, @ts, 0)
			@result_count = User.find_by_sql(["SELECT COUNT(*) AS count_val FROM (SELECT user_id FROM users JOIN posts 
			ON posts.user_id = users.id WHERE Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') >= ? AND 
			Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') <= ? AND posts.user_id IN (SELECT user_id FROM contestants WHERE contestants.status = 2 
			AND contestants.contest_id = ?) GROUP BY user_id) AS u", @contest.start_date, @contest.end_date, @contest.id]).first.count_val.to_i
			@comment_count = Comment.where(thing_id: @contest.thing_id).count
		end
	end
	
	def index
		if current_user
			@contests = Contest.find_by_sql(["SELECT c1.id AS contestant_id, c1.status, c1.contest_id, c1.created_at, c2.contest_title, c2.start_date, c2.end_date, users.id AS inviter_id, users.name AS inviter,
			CASE WHEN c2.start_date > current_date THEN 1 WHEN c2.end_date < current_date THEN 2 ELSE 0 END AS sort_value FROM contestants c1 INNER JOIN contests c2 ON c2.id = c1.contest_id INNER JOIN users ON users.id = c1.inviter_id
			WHERE c1.user_id = ? AND c1.status != 1 ORDER BY c1.status, sort_value, c2.start_date DESC LIMIT 50", current_user.id])
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def edit
		@contest = Contest.where(owner_id: current_user.id, id: params[:id]).first if current_user
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	def update
		@contest = Contest.where(owner_id: current_user.id, id: params[:id]).first if current_user
		if @contest && @contest.update(contest_title: params[:contest][:contest_title])
			flash[:notice] = "Changes saved!"
		else
			flash[:alert] = "Error - " + @contest.errors.full_messages[0]
		end
		redirect_to "/contests/#{@contest.id}"
	end
		
	def load_top_performers
		@contest = Contest.find_by_sql(["SELECT contests.* FROM contests JOIN contestants ON contests.id = contestants.contest_id WHERE contestants.status = 2 AND contestants.user_id = ? AND contests.id = ?", current_user.id, params[:contest_id]]).first if current_user
		if @contest
			@ts = Time.at(params[:timestamp].to_f)
			@result_count = params[:result_count].to_i
			@offset = params[:offset].to_i
			@top_performers = top_performers(@contest.start_date, @contest.end_date, @contest.id, @ts, @offset)
			@new_off = @offset + 20
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def get_friend_list
		if current_user
			@friend_list = contest_friends(params[:contest_id])
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def get_contestant_list
		@contestants = Contestant.joins("JOIN users ON users.id = contestants.user_id").where(contest_id: params[:contest_id], status: 2).select(:image_path, :user_id, :name)
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	private
	def contest_params
		params.require(:contest).permit(:contest_title, :owner_invite_only, :start_date, :end_date)
	end
	def contest_friends(contest_id)
		Friend.find_by_sql(["WITH f AS (SELECT friends.friend_id, users.name, users.image_path FROM friends JOIN users ON users.id = friends.friend_id 
		WHERE friends.status = 2 and friends.user_id = #{current_user.id}), c AS (SELECT status, user_id FROM contestants WHERE contest_id = ?)
		SELECT f.friend_id, f.name, f.image_path, c.status FROM f LEFT OUTER JOIN c ON f.friend_id = c.user_id ORDER BY c.status DESC, f.name", contest_id])
	end
	def top_performers(start_date, end_date, id, ts, offset)
		Post.find_by_sql(["WITH p AS (SELECT SUM(total_points) AS points, user_id, name, image_path, RANK() OVER (ORDER BY sum(total_points) DESC) AS rank 
		FROM results JOIN posts ON posts.id = results.post_id JOIN users ON posts.user_id = users.id WHERE Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') >= ? AND 
		Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') <= ? AND posts.created_at <= ? AND posts.user_id IN (SELECT user_id FROM contestants WHERE 
		contestants.contest_id = ? AND contestants.status = 2) AND posts.active_workout = TRUE GROUP BY user_id, name, image_path ORDER BY points DESC), 
		s AS (SELECT SUM(seconds) as seconds, user_id FROM posts WHERE Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') >= ? AND Date((posts.created_at 
		AT TIME ZONE 'UTC') AT TIME ZONE 'EST') <= ? AND posts.created_at <= ? AND posts.user_id 
		IN (SELECT user_id FROM contestants WHERE contestants.contest_id = ? AND contestants.status = 2) GROUP BY user_id) SELECT p.points, p.user_id, p.name, p.image_path, 
		p.rank, s.seconds FROM p JOIN s ON s.user_id = p.user_id ORDER BY p.points DESC, s.seconds DESC LIMIT 20 OFFSET ?", start_date, end_date, ts, id, start_date, end_date, ts, id, offset])
	end
end
