class RepliesController < ApplicationController
	def like
		@like = ReplyLike.new(user_id: current_user.id, reply_id: params[:id]) if current_user
		if @like && @like.save
			@like_count = ReplyLike.where(reply_id: params[:id]).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def unlike
		@like = ReplyLike.where(reply_id: params[:id], user_id: current_user.id).first if current_user
		if @like && @like.destroy
			@like_count = ReplyLike.where(reply_id: params[:id]).count
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	def retrieve_likes
		@likes = ReplyLike.joins("JOIN users ON users.id = reply_likes.user_id").where(reply_id: params[:id]).select(:user_id, :name, :image_path)
		@count = ReplyLike.where(reply_id: params[:id]).count
		respond_to do |format|
			format.html
			format.js
		end
	end
	def new_reply
		@r = Reply.find(params[:id])
		@reply = Reply.new(comment_id: @r.comment_id)
		respond_to do |format|
			format.js
			format.html
		end
	end
end