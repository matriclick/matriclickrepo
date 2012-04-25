class SupplierAccount < ActiveRecord::Base
	belongs_to :supplier
	has_and_belongs_to_many :industry_categories
	has_many :supplier_contacts
	has_many :supplier_page_views, :dependent => :destroy
	has_many :services
	accepts_nested_attributes_for :supplier_contacts, :allow_destroy => true, :reject_if => lambda { |a| (a[:name].blank? or a[:email].blank?) }
	has_many :products, :dependent => :destroy
	has_one :presentation
	has_many :events
	has_many :bookings
	has_many :conversations, :dependent => :destroy
	has_many :user_accounts, :through => :conversations
	has_many :important_dates, :dependent => :destroy
	has_many :reviews, :as => :reviewable
	has_attached_file :image, 
											:styles => {
												:thumb => "100x100>",
												:small => "200x150>",
												:smaller => "120x90>",
												:profile_info => "130x70>",
												:tiny => "40x40>"
											}, :whiny => false
											
	before_validation :correct_rut_format
	before_validation :correct_phone_number_format
		  
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
	validates_attachment_size :image, :less_than => 1.megabyte
	validates :corporate_name, :public_url, :uniqueness => true
	validates :corporate_name, :fantasy_name, :phone_number, :address, :public_url, :presence => true
	validates :booking_resources, :numericality => { :only_integer => true, :greater_than => 0 }
	
	validates :rut, :rut => true, :allow_blank => true
	
	# FGM: Needs a fix on client_side_validations
	# validates :rut, :uniqueness => true, :allow_blank => true
	
	validates :phone_number, :phone_number => true
	validates :industry_category_ids, :presence => true
  validate :validate_industry_category
  validates_format_of :public_url, :without => /\W/ 
	
	def self.special_filter(user_account = nil)
		ofelia = where('corporate_name like "%ofelia%peinado%maquillaje%"').first
		casa_almarza = where('corporate_name like "%casa%almarza%"').first
		if user_account
			valid_wedding_city = (wc = user_account.wedding_city).present? ? wc.downcase == "santiago" : nil
			valid_budget = (tb = user_account.tentative_budget).present? ? !(tb.budget_range.range.include?("7") || tb.budget_range.range.include?("3")) : nil
			valid_commune = (user_account.communes & ["Las Condes", "Vitacura", "Providencia", "Lo Barnechea", "La Reina"]).present?
		end
		valid_wedding_city && valid_budget && valid_commune ? scoped : scoped - [ofelia, casa_almarza]
	end
	
	# FGM: Bookable = Product/Service that have one or more bookings
	def bookables(options = {})
		options[:date].present? ? @bookings = bookings.where(:date => options[:date]) : @bookings = bookings
		@bookings = @bookings.by_status(:except => options[:except]) if options[:except].present?
		@bookings.collect { |b| b.bookable }.uniq.reject {|a| a.nil?}
	end
	
	# FGM: Check if date should be blocked based on available booking_resources
	def should_create_no_more_booking?(date)
		confirmed_booking_resources(date) >= self.booking_resources
	end
	
	def confirmed_booking_resources(date)
		self.bookables(:date => date, :except => :custom).map{ |b| b.bookings.where(date: date).by_status(status: :confirmed).count * b.booking_resources_consumed }.sum
	end
	
	# FGM: Self information
	def self.approved
		where(:approved_by_us => true, :approved_by_supplier => true)
	end
	
	def self.alphabetized
		order(:corporate_name => :asc)
	end
	
	def self.suggested
		where(:suggested_for_campaign => true)
	end
	
	# FGM: Not used
	def self.random
		order( 'rand()')
	end
	
	def self.by_industry_category(id, name = nil)
		if id
			joins(:industry_categories).where("industry_categories.id = #{id}")
		elsif name
			joins(:industry_categories).where("industry_categories.name = #{name}")
		else
			scoped
		end
	end
	
	def unread_bookings?
		events.supplier_unread.blank? ? false : true
	end

	def is_approved?
		self.approved_by_us and self.approved_by_supplier
	end
	
 	def validate_industry_category
    for p in self.products
      if self.industry_categories.find_all_by_id(p.industry_category_id).length==0 then hasitems=true end    
    end

    for s in self.services
      if self.industry_categories.find_all_by_id(s.industry_category_id).length==0 then hasitems=true end    
    end

    errors.add :IndustryCategories, I18n.t('errors.messages.has_items') if hasitems
	end
	
	def services_and_products_count
		self.services.count + self.products.count
	end
	
	def add_supplier_page_view(ip)
		supplier_page_view = supplier_page_views.where(:created_at => Date.today.beginning_of_month..Date.today.end_of_month, :ip => ip).first || supplier_page_views.build(ip: ip)
		supplier_page_view.count.blank? ? supplier_page_view.count = 1 : supplier_page_view.count += 1
		supplier_page_view.save
	end
	
	private
	# Correct format for Rut (a string without "." or "-")
	def correct_rut_format
	  self.rut.gsub!(/[-]|[.]/, "") unless self.rut.blank?
 	end

	def correct_phone_number_format
		self.phone_number.gsub!(/[^\d^+]/, "") unless self.phone_number.blank?
 	end
 	
 	def self.user_reviewable(user_account)
 		supplier_accounts = []
		user_account.expenses.each do |exp|
			supplier_accounts << exp.supplier_account unless exp.supplier_account.blank?
		end
		#DZF dont repeat suppliers
		supplier_accounts.uniq
 	end
end
