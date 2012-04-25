class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :language

	belongs_to :role
	belongs_to :user_account
	has_many :conversations, :dependent => :destroy
	has_many :supplier_accounts, :through => :conversations
	after_create :ensure_user_account_exists# , :send_user_email
	
	
	def self.owner
		where(:is_owner => true)
	end
	
	#Be sure to create the users with the info you need.
  #Note that facebook and gmail will give you different info from users
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_google(access_token, signed_in_resource=nil)
    data = access_token['user_info']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
  
	def admin?
		role.try(:name) == "admin"
	end
	
	def guest?
		role.try(:name) == "guest"
	end

  def send_user_email
    UserMailer.user_email(self).deliver
  end

	private
	def ensure_user_account_exists
		if user_account.blank?
			self.build_user_account
			self.is_owner = true #DZF if is the first user, then is the owner of the user_account
			self.save :validate => false
		end
	end
  
end
