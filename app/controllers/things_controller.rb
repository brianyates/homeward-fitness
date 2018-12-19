class ThingsController < ApplicationController
	def like
		@like = Like.new(user_id: current_user.id, thing_id: params[:id]) if current_user
		if @like && @like.save
			@like_count = Like.where(thing_id: params[:id]).count
			LikeNotificationJob.perform_later(params[:id], current_user)
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def unlike
		@like = Like.where(thing_id: params[:id], user_id: current_user.id).first if current_user
		if @like && @like.destroy
			@like_count = Like.where(thing_id: params[:id]).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def comment
		@comment = Comment.new(params.require(:comment).permit(:comment).merge(thing_id: params[:thing_id], user_id: current_user.id)) if current_user
		if @comment && @comment.save
			@comment_count = comment_count
			CommentNotificationJob.perform_later(params[:thing_id], current_user, @comment.comment)
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def delete_comment
		@comment = Comment.where(id: params[:id], user_id: current_user.id).first if current_user
		if @comment 		
			@c = @comment
			if @comment.destroy
				@comment_count = comment_count
				respond_to do |format|
					format.html
					format.js
				end
			end
		end
	end
	def load_comments
		@comments = get_comments(params[:thing_id], params[:timestamp].to_f, 0)
		@timestamp = params[:timestamp]
		respond_to do |format|
			format.html
			format.js
		end
	end
	def more_comments
		@comments = get_comments(params[:thing_id], params[:timestamp].to_f, params[:offset])
		@new_off = params[:offset].to_i + 5
		@comment_count = comment_count
		respond_to do |format|
			format.html
			format.js
		end
	end
	def retrieve_likes
		@likes = Like.joins("JOIN users ON users.id = likes.user_id").where(thing_id: params[:id]).select(:user_id, :name, :image_path)
		@count = Like.where(thing_id: params[:id]).count
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	private 
	def comment_count
		Comment.where("comments.thing_id = ?", params[:thing_id]).count
	end
end