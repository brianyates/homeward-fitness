class Badge < ApplicationRecord
	validates :badge_name, presence: true
	validates :badge_description, presence: true
	validates :image_path, presence: true
	
	def badge_alerts(user_id, badge_id)
		@earned_badge = EarnedBadge.new(user_id: user_id, badge_id: badge_id)
		if @earned_badge.save
			@user = User.find(user_id)
			@badge = Badge.find(badge_id)
			Alert.create!(user_id: user.id, message: "You've earned a #{@badge.badge_name} badge", redirect_url: "/users/#{user.id}", image_path: @badge.image_path+".svg")
			MainMailer.badge_earned(user, @badge).deliver_now
		end
	end
end
