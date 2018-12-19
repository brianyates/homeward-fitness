class EmailPreferencesController < ApplicationController
	def edit
		@email_preferences = EmailPreference.find_by_user_id(current_user.id) if current_user
	end
	
	def update
		@email_preferences = EmailPreference.find_by_user_id(current_user.id) if current_user
		if @email_preferences && @email_preferences.update_attributes(preference_params)
			flash[:notice] = "Email preferences updated!"
		else
			flash[:alert] = "Error - " + @email_preferences.errors.full_messages[0]
		end
		redirect_to "/email-preferences"
	end
	
	def unsubscribe
		pref_hash = {"1" => :comment_replies, "2" => :contest_comments, "3" => :contest_info, "4" => :contest_invitation, "5" => :friend_requests, "6" => :leaderboard,
		"7" => :new_badge, "8" => :post_info}
		@email_preference = EmailPreference.where(user_id: params[:uid], token_1: params[:aid], token_2: params[:bid]).first
		@success = true if pref_hash[params[:email_pref]].present? && @email_preference && @email_preference.update_attributes(pref_hash[params[:email_pref]] => 0)
	end

	private
	def preference_params
		params.require(:email_preference).permit(:contest_info, :contest_invitation, :new_badge, :contest_comments, :leaderboard, :friend_requests, :post_info, :comment_replies)
	end	
end
