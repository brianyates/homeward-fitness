class UserCreationJob < ApplicationJob
	queue_as :default
	def perform(user)
		@user = user
		if @user.provider.present?
			MainMailer.welcome_without_verification(@user).deliver_now
		else
			@token = rand(36**72).to_s(36)
			@email_token = EmailToken.create(user_id: @user.id, password: @token)
			MainMailer.welcome_with_verification(@user, @token, @email_token.id).deliver_now
		end
	end
end