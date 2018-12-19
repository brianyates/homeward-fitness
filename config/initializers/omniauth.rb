OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '834984413377048', ENV['FACEBOOK_SECRET'], scope: "public_profile", image_size: "large",
	client_options: {
		site: 'https://graph.facebook.com/v2.12',
		authorize_url: "https://www.facebook.com/v2.12/dialog/oauth"
	}
	provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'], name: 'google', scope: 'profile, email', image_aspect_ratio: 'square', image_size: 150
end