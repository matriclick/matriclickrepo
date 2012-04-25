# coding:utf-8
Matri::Application.routes.draw do

  

	# RATING (STARS)
	post "rate/:class/:id" => 'application#rate', as: 'rate'
	
	# CAMPAIGN
  resources :campaign_gallery_items
	resources :campaign_anecdotes
	resources :campaign_user_account_infos
	resources :rocks
	
  get "campaign/how_to_win"
	get "campaign/user_story/(:id)" => 'campaign#user_story', as: 'user_story'
	get "campaign/vote_up/(:id)" => 'campaign#vote_up', as: 'campaign_vote_up'
	get "campaign/anecdotes/(:id)" => 'campaign#anecdotes', as: 'anecdotes'
  get "campaign/supplier_gallery/(:id)" => 'campaign#supplier_gallery', as: 'supplier_gallery'
  get "campaign/bases"
  get "campaign/wedding_of_the_year"
	get "campaign/suggested_wedding"
  get "campaign/give_it_away"
  get "campaign/studiosnaps"
  get "campaign/noviosparis"
	post "campaign/create_rock" => 'campaign#create_rock', as: 'create_rock'

	# DRESSES
	post 'dresses/notify_request/:id' => 'dresses#notify_request', as: 'dresses_notify_request'
	get 'dresses/dress_request/:id' => 'dresses#dress_request', as: 'dresses_dress_request'
	get "dresses/menu" => 'dresses#menu'
	resources :dresses

	# BLOG
  resources :posts do
		resources :blog_comments  	
  end
  get 'blog' => 'posts#blog'
  
  resources :contacts

	# CEREMONY
	get "ceremonies/menu"
  get "ceremonies/:ceremony_type_id/places" => 'ceremonies#places', as: 'ceremonies_places'
	resources :ceremonies
	resources :ceremony_types do
		resources :tips
	end
	# CEREMONY TIPS


  # MATRICHECKLIST
	match "matrichecklist" => 'matrichecklist#index', as: 'matrichecklist_index'
  get "matrichecklist/index"
  get "matrichecklist/reminders"
  get "matrichecklist/activity"
  get "matrichecklist/edit"
  get "matrichecklist/add"
  get "matrichecklist/ganttchart"
  get "matrichecklist/done"
  post "matrichecklist/create"
  post "matrichecklist/reminders"
  post "matrichecklist/activate_reminder"
  put "matrichecklist/update"
  delete "matrichecklist/delete_reminder"
  delete "matrichecklist/delete"
  get 'matrichecklist/done'
  get 'matrichecklist/view_activity'
      
  # USER_PROFILE
  get 'user_profile'											=> 'user_profile#show',					as: 'user_profile'
  get 'user_profile/edit'									=> 'user_profile#edit',					as: 'edit_user_profile'
	put 'user_profile/edit'									=> 'user_profile#update',				as: 'update_user_profile'
  get 'user_profile/add_couple'						=> 'user_profile#add_couple',		as: 'user_profile_add_couple'
  get 'user_profile/add_user'							=> 'user_profile#add_user',			as: 'user_profile_add_user'
  get 'user_profile/show_people'					=> 'user_profile#show_people',	as: 'user_profile_show_people'
  post 'user_profile/create_user'					=> 'user_profile#create_user',	as: 'user_profile_create_user'
  get 'user_profile/edit_user/:id'				=> 'user_profile#edit_user',		as: 'user_profile_edit_user'
  put 'user_profile/update_user/:id'			=> 'user_profile#update_user',	as: 'user_profile_update_user'
  delete 'user_profile/destroy_user/:id'	=> 'user_profile#destroy_user', as: 'user_profile_destroy_user'
  delete 'user_profile/sign_in_user'			=> 'user_profile#sign_in_user', as: 'user_profile_sign_in_user'
	
	# BOOKING
	match 'bookings'											=> 'bookings#booking_list', 		as: 'bookings_booking_list'
	match 'bookings/update_booking/:id' 		=> 'bookings#update_booking', 	as: 'bookings_update_booking'
	
	# BUDGET
	match 'budget_menu' => 'budgets#menu', as: 'budget_menu'
  get 'budgets/instructions' => 'budgets#instructions', as: 'budget_instructions'
	get 'budgets/econ' => 'budgets#econ', as: 'econ_budget'
	get 'budgets/standard' => 'budgets#standard', as: 'standard_budget'
	get 'budgets/premium' => 'budgets#premium', as: 'premium_budget'
	get 'budgets/settings' => 'budgets#settings', as: 'budget_settings'
	put	'budgets/update_budget_config' => 'budgets#update_budget_config', as: 'update_budget_config'
	resources :budgets

	# SUPPLIERS CATALOG
	scope ":public_url" do
		get "suppliers_catalog/:id/supplier_description" => 'suppliers_catalog#supplier_description', as: 'supplier_description'
		get "suppliers_catalog/:id/supplier_products_and_services" => 'suppliers_catalog#supplier_products_and_services', as: 'supplier_products_and_services'
		get "suppliers_catalog/:id/supplier_contacts" => 'suppliers_catalog#supplier_contacts', as: 'supplier_contacts'
		post 'suppliers_catalog/:supplier_id/ask_reference' => 'reference_requests#ask_reference', as: 'suppliers_catalog_ask_reference'
		get "suppliers_catalog/:id/supplier_reviews" => 'suppliers_catalog#supplier_reviews', as: 'supplier_reviews'
  end
  
	# PRODUCTS AND SERVICES CATALOG
	get "products_and_services_catalog/index" => 'products_and_services_catalog#index', as: 'products_and_services_catalog_index'
	match 'products_and_services_catalog' => 'products_and_services_catalog#select_industry_category', as: 'products_and_services_catalog_select_industry_category'
	get 'products_and_services_catalog/:id/description' => 'products_and_services_catalog#description', as: 'products_and_services_catalog_description'
	get 'products_and_services_catalog/:id/faqs' => 'products_and_services_catalog#faqs', as: 'products_and_services_catalog_faqs'
	get 'products_and_services_catalog/:id/conversations' => 'products_and_services_catalog#conversations', as: 'products_and_services_catalog_conversations'
	get 'products_and_services_catalog/:id/service_audio_and_video' => 'products_and_services_catalog#audio_and_video', as: 'products_and_services_catalog_audio_and_video'
	get 'products_and_services_catalog/:id/contacts' => 'products_and_services_catalog#contacts', as: 'products_and_services_catalog_contacts'
	post 'products_and_services_catalog/:id/ask_reference' => 'reference_requests#ask_reference', as: 'products_and_services_catalog_ask_reference_ask_reference'
	post 'products_and_services_catalog/:id/add_to_budget/:budget_type_id' => 'products_and_services_catalog#add_to_budget', as: 'products_and_services_catalog_add_to_budget'
	#TCT: Disabled route because its not used and is throwing erros because of google bots...
	# get 'products_and_services_catalog/:id/schedule_day' => 'products_and_services_catalog#schedule_day', as: 'products_and_services_catalog_schedule_day'
	get 'products_and_services_catalog/:id/download_file/:attached_file' => 'products_and_services_catalog#download_file', as: 'products_and_services_catalog_download_file'
	# PRODUCTS AND SERVICES => BOOKINGS
	get 'products_and_services_catalog/(:object_class)(.:id)/bookings' => 'products_and_services_catalog#bookings', as: 'products_and_services_catalog_bookings'
	post 'products_and_services_catalog/add_booking' => 'products_and_services_catalog#add_booking', as: 'products_and_services_catalog_add_booking'
	delete 'products_and_services_catalog/destroy_booking/:id' => 'products_and_services_catalog#destroy_booking', as: 'products_and_services_catalog_destroy_booking'


  #MATRISHEETS
  match '/invitees/upload' => 'matrisheets#upload', as: 'matrisheet_upload'
	match '/invitees/download' => 'matrisheets#download', as: 'matrisheet_download'
	match '/invitees/base_file' => 'matrisheets#send_base_file', as: 'matrisheet_send_base_file'
	

  devise_for :suppliers

	devise_scope :supplier do
		match '/supplier_login' => "devise/sessions#new"
	end

	devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks', :registrations => 'users/registrations' }

  devise_scope :user do
    match '/user_sign_up' => "devise/registrations#new"
  end

	resources :suppliers do
		resource :supplier_account, as: :account do
			# CONVERSATIONS
			get 'conversations' => 'conversations#index', as: 'conversations'
			get 'conversations/download_file/:attached_file' => 'conversations#download_file', as: 'conversations_download_file'
			# STATISTICS
			get 'statistics' => 'statistics#index', as: 'statistics'
			# NO MORE BOOKINGS
			put 'set_bookings_lock' => 'supplier_accounts#set_bookings_lock'
			resources :events
				put 'update_booking_confirmed/:id' => 'events#update_booking_confirmed', as: 'update_booking_confirmed'
				post 'update_soft_delete/:id' => "events#update_soft_delete", as: "update_soft_delete"
			resources :important_dates
			member do
			  match 'calendar'  => 'supplier_accounts#calendar', as: 'calendar'
				get 'new_booking' => 'supplier_accounts#new_booking', as: 'new_booking'
				post 'create_booking' => 'supplier_accounts#create_booking', as: 'create_booking'
	    end
			resources :supplier_contacts
			resources :products	do
				match '/update_multiple' => 'product_images#update_multiple', as: '/update_multiple'
				resources :product_images do
					member do
						put "set_image_index" => 'product_images#set_image_index', as: 'set_image_index'
						put "toggle_active" => 'product_images#toggle_active', as: 'toggle_active'
					end
				end
			end
			resource :presentation do
				resources :presentation_images
			end
			resources :services do
				match '/update_multiple' => 'service_images#update_multiple', as: '/update_multiple'
	      resources :service_images do
					member do
						put "set_image_index" => 'service_images#set_image_index', as: 'set_image_index'
						put "toggle_active" => 'service_images#toggle_active', as: 'toggle_active'
					end
				end
			  resources :schedules
	    end
		end
	end
  resources :product_types, :industry_categories, :contact_types, :users, :feedbacks, :invitee_groups, :invitations
	
  
	match 'invitees_menu' => 'invitees#menu', as: 'invitees_menu'	
	resources :invitees do							
		collection do			
			get 'statistics' => 'invitees#statistics', as: 'statistics'			
		end
	end
	

	# EXPENSES
	get 'points' => 'expenses#points', as: 'points'
	get 'expenses/filter_supplier_accounts' => 'expenses#filter_supplier_accounts'	
	resources :expenses do
		collection do
			get 'statistics' => 'expenses#statistics', as: 'statistics'
		end
	end


	resources :conversations
	#Messages inside conversations
	post 'conversations/create_message' => 'conversations#create_message', as: 'conversations_create_message'
	#post 'conversations/create_by_service' => 'conversations#create_by_service', as: 'conversations_create_by_service'
	# USER CONVERSATIONS
	match "user_conversations"=>'user_conversations#index', as:'user_conversations_index'
	
	
	# REVIEWS
	get 'reviews/index' => 'reviews#index', as: 'reviews_index'
	post 'reviews/create' => 'reviews#create', as: 'reviews_create'
	
	# FGM Routes for the home controller (non-RESTful)
	scope 'home' do
		match '/welcome' => "home#index"
		get 'terms' => "home#terms"
		get '/company' => "home#company"
		get '/faq' => "home#faq"
		get '/criteria' => "home#criteria"
		get '/como_nace' => "home#como_nace"
		get '/press' => "home#press"
		get '/work_with_us' => "home#work_with_us"
		get '/tour' => "home#tour"
	end

	match '/supplier/main' => "supplier_accounts#show", as: :supplier_home
	
	scope ':public_url' do #DZF this alows to search a supplier without crashing with resources in the "/ "
		root :to => "suppliers_catalog#supplier_description"
	end
  root :to => "home#login" 
  
  # ADMINISTRATION
  get "administration/index"
  get "administration/show_supplier_account/:id" => 'administration#show_supplier_account', as: 'administration_show_supplier_account'
  get "administration/show_supplier_products/:id" => 'administration#show_supplier_products', as: 'administration_show_supplier_products'
  get "administration/show_supplier_services/:id" => 'administration#show_supplier_services', as: 'administration_show_supplier_services'
  get "administration/edit_supplier_account/:supplier_account_id" => 'administration#edit_supplier_account', as: 'administration_edit_supplier_account'
  get "administration/edit_supplier_product/:product_id" => 'administration#edit_supplier_product', as: 'administration_edit_supplier_product'
  get "administration/edit_supplier_service/:service_id" => 'administration#edit_supplier_service', as: 'administration_edit_supplier_service'
  put "administration/update_supplier_account/:id" => 'administration#update_supplier_account', as: 'administration_update_supplier_account'
  put "administration/update_supplier_product/:id" => 'administration#update_supplier_product', as: 'administration_update_supplier_product'
  put "administration/update_supplier_service/:id" => 'administration#update_supplier_service', as: 'administration_update_supplier_service'
  delete "administration/destroy_supplier/:id" => 'administration#destroy_supplier', as: 'administration_destroy_supplier'
  delete "administration/destroy_supplier_product/:id" => 'administration#destroy_supplier_product', as: 'administration_destroy_supplier_product'
  delete "administration/destroy_supplier_service/:id" => 'administration#destroy_supplier_service', as: 'administration_destroy_supplier_service'

  # ADMINISTRATION REVIEWS
  get	"administration/reviews"
  get "administration/new_review/:id" => "administration#new_review", as: "administration_new_review"
  get "administration/edit_review/:id" => "administration#edit_review", as: "administration_edit_review"
  put "administration/update_review/:id" => "administration#update_review", as: "administration_update_review"
  delete "administration/destroy_review/:id" => "administration#destroy_review", as: "administration_destroy_review"
end
