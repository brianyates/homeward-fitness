class FriendsController < ApplicationController
	def add
		@friend = Friend.new(user_id: current_user.id, friend_id: params[:id], status: 1, email_request: false) if current_user
		if @friend && @friend.save
			CreateFriendJob.perform_later(current_user, params[:id], @friend.id, false)
			@request_count = Friend.where(user_id: current_user.id, status: 0).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def destroy
		@friend = Friend.where(id: params[:id], user_id: current_user.id).first if current_user
		if @friend && Friend.find(@friend.paired_record).destroy && @friend.destroy
			if params[:remote].present?
				@request_count = Friend.where(user_id: current_user.id, status: 0).count
				respond_to do |format|
					format.html
					format.js
				end
			else
				redirect_back fallback_location: "/weekly-workouts"
			end
		end
	end
	def accept
		@friend = Friend.where(id: params[:id], user_id: current_user.id).first if current_user
		@init_status = @friend.status
		if @friend && @friend.update_attributes(status: 2) && Friend.find(@friend.paired_record).update_attributes(status: 2)
			Alert.create!(user_id: @friend.friend_id, message: "#{current_user.name} accepted your friend request", redirect_url: "/users/#{current_user.id}", image_user: current_user.id) unless (@init_status == 2)
			if params[:remote].present?
				@request_count = Friend.where(user_id: current_user.id, status: 0).count
				respond_to do |format|
					format.html
					format.js
				end
			else
				redirect_back fallback_location: "/weekly-workouts"
			end
		end
	end
	def show_requests
		@requests = Friend.joins("JOIN users ON users.id = friends.friend_id").where(user_id: current_user.id, status: 0).select(:id, :name, :friend_id, :image_path, :created_at).order(created_at: :desc).limit(50) if current_user
		respond_to do |format|
			format.html
			format.js
		end
	end
	def index
		if current_user
			@user = User.where(id: params[:id]).select(:name, :id, :image_path).first
			@friends = get_friends(0, params[:id])
		end
	end
end
