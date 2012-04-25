class Dress < ActiveRecord::Base
	has_many :dress_images, :dependent => :destroy
	accepts_nested_attributes_for :dress_images, :reject_if => proc { |a| a[:dress].blank? }, :allow_destroy => true
	
	validates :seller_email, :email => true, :allow_blank => true
	validates :seller_email, :presence => true, :if => :independent?
	
	def independent?
		independent
	end
end
