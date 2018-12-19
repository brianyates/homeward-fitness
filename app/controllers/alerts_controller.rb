class AlertsController < ApplicationController
	def read_all
		if current_user
			Alert.where(user_id: current_user.id).update_all(read: true)
			@alerts = alert_index
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def index
		@alerts = alert_index if current_user
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	def action
		@alert = Alert.find(params[:id])
		redirect_to @alert.redirect_url if (@alert && @alert.update_attributes(read: true))
	end
	
	def cheer
		@user = User.find(params[:id])
		@alert = Alert.new(user_id: @user.id, message: "#{current_user.name} cheered you on! That's pretty cool.", redirect_url: "/users/#{current_user.id}", 
		image_user: current_user.id) if (current_user && @user)
		if @alert.save
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def challenge
		@user = User.find(params[:id])
		@alert = Alert.new(user_id: @user.id, message: "Uh oh...#{current_user.name} challenged you! Are you gonna take that?", redirect_url: "/users/#{current_user.id}", 
		image_user: current_user.id) if (current_user && @user)
		if @alert.save
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	private
	def alert_index
		Alert.find_by_sql(["SELECT a.id, a.message, a.read, a.created_at, COALESCE(a.image_path, u.image_path, 'default_avatar.svg') AS image_path FROM alerts a LEFT OUTER JOIN users u ON u.id = a.image_user 
		WHERE a.user_id = ? ORDER BY a.created_at DESC LIMIT 50", current_user.id])
	end	
end
