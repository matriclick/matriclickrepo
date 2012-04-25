class Supplier < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :language
	has_one :supplier_account, :dependent => :destroy
	has_many :star_ratings, :as => :rateable
	
	after_create :ensure_supplier_account_exists
	after_create :send_welcome_email
	
	validates :email, :email => true
 
  def ensure_supplier_account_exists
	  if supplier_account.blank?
		  # FGM: Generate account
		  self.build_supplier_account
		  # FGM: We'll skip validations the first time. The user will have to fill the account data to continue.. (application_controller :before_filter)
		  self.supplier_account.save :validate => false
	  end
	  self.supplier_account.presentation = Presentation.create
  end

  def send_welcome_email
    SupplierMailer.welcome_email(self).deliver
  end
end
