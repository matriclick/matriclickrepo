class Users::RegistrationsController < Devise::RegistrationsController

  def new
    resource = build_resource({})
    resource.email = params[:email] unless params[:email].blank? 
    respond_with_navigational(resource){ render_with_scope :new }
  end
  
  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    elsif User.find_by_email(resource.email).present? #Pequeño hack que permite entrar y registrarse desde el mismo formulario
      user = User.find_for_authentication(:email => resource.email)
      if user.valid_password?(resource.password)
        user.password = resource.password
        sign_in('user', user)
        redirect_to after_sign_in_path_for(resource)
      else
        set_flash_message :error, :taken
        clean_up_passwords(resource)
        redirect_to user_sign_up_path(:email => resource.email)
      end
    else
      if resource.password.empty?
        set_flash_message :error, :nil_password
      else
        set_flash_message :error, :short_password
      end
      clean_up_passwords(resource)
      redirect_to user_sign_up_path(:email => resource.email)
    end
  end

	def after_sign_up_path_for(resource)
		logger.info	">>>>>>>>>>>>>>>>> USERS/REGISTRATIONS CONTROLLER :: AFTER SIGN UP PATH FOR"
		if params[:campaign] == 'true'
			logger.info ">>>>>>>>>>>>>> params[:CAMPAIGN] == 'TRUE'"
			edit_user_profile_path(:campaign => true)
		else
			blog_path
		end
  end

  def after_inactive_sign_up_path_for(resource)
    '/users/sign_up'
  end
end
