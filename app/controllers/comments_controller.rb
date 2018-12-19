class CommentsController < ApplicationController
	def new_reply
		@reply = Reply.new(comment_id: params[:id])
		respond_to do |format|
			format.js
			format.html
		end
	end
	def reply
		@reply = Reply.new(params.require(:reply).permit(:comment).merge(user_id: current_user.id, comment_id: params[:id])) if current_user
		if @reply && @reply.save
			ReplyNotificationJob.perform_later(@reply, current_user)
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def get_replies
		@replies = Reply.joins("JOIN users ON users.id = replies.user_id").where(comment_id: params[:id]).select(:user_id, :created_at, :comment, :id, :image_path,
		:name).order(:created_at)
		respond_to do |format|
			format.html
			format.js
		end
	end
	def delete_reply
		@reply = Reply.where(id: params[:id], user_id: current_user.id).first if current_user
		if @reply		
			@r = @reply
			if @reply.destroy
				respond_to do |format|
					format.html
					format.js
				end
			end
		end
	end
	def like
		@like = CommentLike.new(user_id: current_user.id, comment_id: params[:id]) if current_user
		if @like && @like.save
			@like_count = CommentLike.where(comment_id: params[:id]).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def unlike
		@like = CommentLike.where(comment_id: params[:id], user_id: current_user.id).first if current_user
		if @like && @like.destroy
			@like_count = CommentLike.where(comment_id: params[:id]).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def retrieve_likes
		@likes = CommentLike.joins("JOIN users ON users.id = comment_likes.user_id").where(comment_id: params[:id]).select(:user_id, :name, :image_path)
		@count = CommentLike.where(comment_id: params[:id]).count
		respond_to do |format|
			format.html
			format.js
		end
	end
end