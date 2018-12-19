task :completed_contests => :environment do
	puts("Searching for completed contests...")
	@contests = Contest.where(end_date: Date.today - 1)
	puts("Found #{@contests.length} completed contest(s)...")
	if @contests.length > 0
		@contests.each do |c|
			@top_performers = Post.find_by_sql(["WITH p AS (SELECT SUM(total_points) AS points, user_id, name, image_path, RANK() OVER (ORDER BY sum(total_points) DESC) AS rank 
			FROM results JOIN posts ON posts.id = results.post_id JOIN users ON posts.user_id = users.id WHERE Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') >= ? AND 
			Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') <= ? AND posts.user_id IN (SELECT user_id FROM contestants WHERE 
			contestants.contest_id = ? AND contestants.status = 2) AND posts.active_workout = TRUE GROUP BY user_id, name, image_path ORDER BY points DESC), 
			s AS (SELECT SUM(seconds) as seconds, user_id FROM posts WHERE Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE 'EST') >= ? AND Date((posts.created_at 
			AT TIME ZONE 'UTC') AT TIME ZONE 'EST') <= ? AND posts.user_id IN (SELECT user_id FROM contestants WHERE contestants.contest_id = ? AND contestants.status = 2) 
			GROUP BY user_id) SELECT p.points, p.user_id, p.name, p.image_path, p.rank, s.seconds FROM p JOIN s ON s.user_id = p.user_id ORDER BY p.points 
			DESC, s.seconds DESC LIMIT 20", c.start_date, c.end_date, c.id, c.start_date, c.end_date, c.id])
			@contestants = Contestant.joins("JOIN users ON users.id = contestants.user_id JOIN email_preferences ON 
			email_preferences.user_id = users.id").where(contest_id: c.id).select(:email, :name, :user_id, :email_validated, :token_1, :token_2, :contest_info)
			@contestants.each do |u|
				MainMailer.contest_completed(@top_performers, c, u).deliver_now if (u.contest_info == 1 && u.email_validated == true)
				Alert.create!(user_id: u.user_id, message: "Fitness Contest '#{c.contest_title}' is complete", redirect_url: "/contests/#{c.id}", image_path: "contest_trophy.svg")
			end
			@top_performers.each do |t|
				BadgeCreationJob.perform_now(t.user_id, 18) if t.rank==1 #contest champ badge
			end
		end
	end
	puts("Done.")
end