Rails.application.routes.draw do
  
	root 'welcome#index'

	post '/signup' => 'users#create'
	
	get '/login' => 'sessions#new'

	post '/login' => 'sessions#create'
	
	post '/login-sync' => 'sessions#create_sync'

	delete '/logout' => 'sessions#destroy'
	
	get '/weekly-workouts' => 'workouts#current'
	
	get '/signup' => 'users#new'
	
	get '/settings' => 'users#edit'
	
	patch '/update-settings' => 'users#update'
	
	delete '/delete-user' => 'users#destroy'
	
	get '/workouts/new' => 'workouts#new'
	
	post '/workouts/new' => 'workouts#create'
	
	get '/instructors' => 'instructors#index'
	
	get '/instructors/new' => 'instructors#new'
	
	post '/instructors/new' => 'instructors#create'
	
	get '/instructors/:id' => 'instructors#show'
	
	get '/instructors/:id/owner' => 'instructors#show_owner'
	
	get '/instructors/:id/owner/edit' => 'instructors#edit'
	
	patch '/instructors/:id/owner/edit/:field' => 'instructors#update'
	
	get '/workouts/:id' => 'workouts#show'
	
	post '/workouts/:id' => 'posts#create'
	
	get '/workouts/:id/edit' => 'workouts#edit'
	
	patch '/workouts/:id/edit' => 'workouts#update'
	
	delete '/workouts/:id/edit' => 'workouts#destroy'
	
	get '/all-workouts' => 'workouts#index'
	
	get '/posts/:id' => 'posts#show'
	
	get '/posts/:id/edit' => 'posts#edit'
	
	patch '/posts/:id/edit' => 'posts#update'
	
	delete '/posts/:id' => 'posts#destroy'
	
	get '/active-workouts' => 'workouts#edit_active'
	
	post '/active-workouts' => 'workouts#update_active'
	
	get '/leaderboard' => 'leaderboard#index'
	
	get '/auth/:provider/callback' => 'sessions#create_from_omniauth'
	
	get '/change-password' => 'users#change_password'
	
	patch '/change-password' => 'users#update_password'
	
	get '/users/:id' => 'users#show'
	
	get '/users/:id/workouts' => 'users#workouts'
	
	get '/users/:id/workouts/table' => 'users#workouts_table', as: 'workouts_table'
	
	patch '/read-alerts' => 'alerts#read_all'
	
	get '/get-alerts' => 'alerts#index'
	
	get '/get-friend-requests' => 'friends#show_requests'
	
	get '/alerts/:id' => 'alerts#action'
	
	post '/leaderboard' => 'leaderboard#filter'
	
	post '/add-friend/:id' => 'friends#add'
	
	delete '/unfriend/:id' => 'friends#destroy'
	
	post '/accept-friend/:id' => 'friends#accept'
	
	post '/decline-friend/:id' => 'friends#decline'
	
	get '/friends/:id' => 'friends#index'
	
	post '/stage-email' => 'stagings#create'
	
	get '/contact-us' => 'contacts#new'
	
	post '/contact-us' => 'contacts#create'
	
	get '/all-contacts' => 'contacts#index'
	
	post '/contact-us/resolve/:id' => 'contacts#resolve'
	
	post '/cheer/:id' => 'alerts#cheer'
	
	post '/challenge/:id' => 'alerts#challenge'
	
	post '/unlike/:id' => 'things#unlike'
	
	post '/like/:id' => 'things#like'
	
	get '/get-likes/:id' => 'things#retrieve_likes'
	
	get '/get-comment-likes/:id' => 'comments#retrieve_likes'
	
	get '/get-reply-likes/:id' => 'replies#retrieve_likes'
	
	post '/comment/:thing_id' => 'things#comment'
	
	delete '/comment/:id' => 'things#delete_comment'
	
	get '/more-comments' => 'things#more_comments'
	
	post '/comment-like/:id' => 'comments#like'
	
	post '/comment-unlike/:id' => 'comments#unlike'
	
	get '/reply/:id' => 'comments#new_reply'
	
	get '/reply-reply/:id' => 'replies#new_reply'
	
	post '/reply/:id' => 'comments#reply'
	
	delete '/reply/:id' => 'comments#delete_reply'
	
	get '/get-replies/:id' => 'comments#get_replies'
	
	post '/reply-like/:id' => 'replies#like'
	
	post '/reply-unlike/:id' => 'replies#unlike'
	
	get '/live-classes' => 'live_classes#index'
	
	get '/more-user-posts/:id' => 'users#more_posts'
	
	post '/change-user-img' => 'avatars#change_user'
	
	post '/change-instructor-img' => 'avatars#change_instructor'
	
	get '/change-pic' => 'users#change_pic'
	
	post '/crop-user-avatar/:id' => 'avatars#crop_user'

	post '/crop-instructor-avatar/:id' => 'avatars#crop_instructor'
	
	post '/cancel-crop-user/:id' => 'avatars#cancel_user'
	
	post '/cancel-crop-instructor/:id' => 'avatars#cancel_instructor'
	
	get '/internal-signup' => 'users#internal_signup'
	
	patch '/internal-signup' => 'users#update_signup'
	
	get '/main-menu-workouts' => 'workouts#main_menu_workouts'
	
	get '/top-menu-workouts' => 'workouts#top_menu_workouts'
	
	get '/get-emoji-form' => 'users#get_emoji_form'
	
	post '/set-emoji' => 'users#set_emoji'
	
	get '/account-recovery' => 'users#new_account_recovery'
	
	post '/account-recovery' => 'users#send_account_recovery'
	
	get '/account-recovery/password-reset' => 'users#edit_account_recovery'
	
	patch '/account-recovery/password-reset' => 'users#update_account_recovery'
	
	get '/validate-user' => 'users#validate_email'
	
	get '/accept-owner-invitation' => 'instructors#accept_invitation'
	
	post '/resend-verification-email' => 'users#resend_email'
	
	get '/newsfeed' => 'newsfeed#index'
	
	get '/more-newsfeed-posts' => 'newsfeed#more_posts'
	
	get '/load-comments' => 'things#load_comments', as: 'load_comments'
	
	post '/change-view/:id' => 'instructors#change_view'
	
	get '/invite-owner' => 'instructors#new_invite'
	
	post '/invite-owner' => 'instructors#create_invite'
	
	get '/about-us' => 'info#about_us'
	
	get '/privacy-policy' => 'info#privacy_policy'
	
	get '/legal-terms' => 'info#legal_terms'
	
	get '/how-it-works' => 'info#how_it_works'
	
	get '/all-users' => 'admin#all_users'
	
	get '/contests/new' => 'contests#new'
	
	post '/contests/new' => 'contests#create'
	
	get '/contests/:contest_id' => 'contests#show'
	
	get '/get-contests' => 'contests#index'
	
	get '/get-contest-friend-list/:contest_id' => 'contests#get_friend_list'
	
	post '/invite-contestant/:contest_id/:user_id' => 'contestants#invite'
	
	post '/accept-contest/:contest_id' => 'contestants#accept'
	
	post '/decline-contest/:contest_id' => 'contestants#decline'
	
	post '/contest-invite-by-email/:contest_id' => 'contest_stagings#invite_by_email'
	
	get '/get-contestant-list/:contest_id' => 'contests#get_contestant_list'
	
	get '/edit-contest/:id' => 'contests#edit'
	
	post '/update-contest/:id' => 'contests#update'
	
	get '/all-badges' => 'admin#all_badges'
	
	post '/badges' => 'admin#create_badge'
	
	get '/get-badges/:user_id' => 'users#get_badges'
	
	get '/get-user-friend-list/:user_id' => 'users#get_user_friend_list'
	
	get '/badges/:id/edit' => 'admin#edit_badge'
	
	patch '/badges/:id/edit' => 'admin#update_badge'
	
	delete '/badges/:id' => 'admin#destroy_badge'
	
	get '/load-top-performers' => 'leaderboard#load_top_performers'
	
	get '/load-top-performances' => 'leaderboard#load_top_performances'
	
	get '/load-top-contest-performers' => 'contests#load_top_performers'
	
	get '/email-preferences' => 'email_preferences#edit'
	
	patch '/email-preferences' => 'email_preferences#update'
	
	get '/unsubscribe' => 'email_preferences#unsubscribe'
	
	get '/get-user-chart/:id' => 'users#get_user_chart'
	
	get '/get-instructor-map/:id' => 'instructors#get_instructor_map'
	
end
