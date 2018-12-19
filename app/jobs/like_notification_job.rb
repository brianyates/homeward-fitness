class LikeNotificationJob < ApplicationJob
	queue_as :default
	#This job will alert the user their post was liked, but only once (repeat likes from the same user will not create notifications)
	def perform(thing_id, user)
		@thing = Thing.find(thing_id)
		@user = user
		if @thing.thing_type == 1
			@post = Post.find_by_thing_id(@thing.id)
			unless @post.user_id == @user.id
				@thing_email = ThingEmail.where(thing_id: @thing.id, user_id: @user.id, recipient_id: @post.user_id, category: 0).first
				unless @thing_email.present?
					@recipient = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :post_info, :email_validated).where(id: @post.user_id).first
					Alert.create(user_id: @recipient.id, message: "#{@user.name} liked your post", redirect_url: "/posts/#{@post.id}", image_user: @user.id)
					MainMailer.post_liked(@recipient, @user, @post.id).deliver_now if (@recipient.post_info == 1 && @recipient.email_validated == true)
					ThingEmail.create(thing_id: @thing.id, user_id: @user.id, recipient_id: @post.user_id, category: 0)
				end
			end
		end
	end
end
