class BadgeCreationJob < ApplicationJob
	queue_as :default
	def perform(user_id, badge_id, post_id = nil)
		@earned_badge = EarnedBadge.new(user_id: user_id, badge_id: badge_id)
		if @earned_badge.save
			@user = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :new_badge, :email_validated).where(id: user_id).first
			@badge = Badge.find(badge_id)
			Alert.create!(user_id: @user.id, message: "You've earned the #{@badge.badge_name} Badge", redirect_url: "/users/#{@user.id}#fitness-badges", image_path: "badges/#{@badge.image_path}.svg")
			MainMailer.badge_earned(@user, @badge).deliver_now if (@user.new_badge == 1 && @user.email_validated == true)
		end
	end
end