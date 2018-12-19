class User < ApplicationRecord
    has_secure_password
    before_save { |user| user.email = user.email.downcase }
    validates :email, presence: true, uniqueness: {case_sensitive: false, message: "address already taken."}
    validates :name, presence: true, length: { maximum: 100 }
	validates :password, presence: true, length: { minimum: 8 }, on: :create
	before_create :add_avatar
	after_create :user_creation_job
	before_destroy :delete_stuff
	
	private
	def self.from_omniauth(auth)
		where(provider: auth.provider, provider_uid: auth.uid).first_or_create.tap do |user|
			user.name = auth.info.name
			user.provider_uid = auth.uid
			user.provider = auth.provider
			user.email = auth.info.email
			user.image_path = auth.info.image.sub "http://", "https://"
			user.password = rand(36**30).to_s(36)
			user.email_validated = true
			user.save
		end
	end
	def user_creation_job
		@token_1 = rand(36**72).to_s(36)
		@token_2 = rand(36**72).to_s(36)
		EmailPreference.create!(user_id: self.id, token_1: @token_1, token_2: @token_2)
		@stagings = Staging.where(email: self.email)
		@stagings.each do |s|
			@f_1 = Friend.create!(user_id: s.user_id, friend_id: self.id, status: 1, email_request: false)
			@f_2 = Friend.create!(user_id: self.id, friend_id: s.user_id, status: 0, email_request: false, paired_record: @f_1.id)
			@f_1.update!(paired_record: @f_2.id)
			BadgeCreationJob.perform_later(s.user_id, 16)
		end
		@stagings.destroy_all
		@contest_stagings = ContestStaging.where(email: self.email)
		@contest_stagings.each do |c|
			Contestant.create!(user_id: self.id, contest_id: c.contest_id, status: 0, inviter_id: c.inviter_id)
		end
		@contest_stagings.destroy_all
		UserCreationJob.perform_later(self)
	end
	def add_avatar
		unless self.image_path.present?
			letter = self.name[0,1].downcase
			letter =~ /[a-z]/ ? (self.image_path = "letters/#{letter}.svg") : (self.image_path = "default_avatar.svg")
		end
	end
	def delete_stuff
		Friend.where("user_id = ? OR friend_id = ?", self.id, self.id).destroy_all
		Reply.where(user_id: self.id).destroy_all
		Post.where(user_id: self.id).destroy_all
		Result.joins("JOIN posts ON posts.id = results.post_id").where("posts.user_id = ?", self.id).destroy_all
		Comment.where(user_id: self.id).destroy_all
		CommentLike.where(user_id: self.id).destroy_all
		Alert.where(user_id: self.id).destroy_all
		Like.where(user_id: self.id).destroy_all
		ReplyLike.where(user_id: self.id).destroy_all
		Avatar.where(user_id: self.id).destroy_all
	end
end
