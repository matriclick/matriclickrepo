class Review < ActiveRecord::Base
	belongs_to :reviewable, :polymorphic => true
	has_one :star_rating, :as => :rateable, :dependent => :destroy
	
	validates :content, :presence => true
	
	accepts_nested_attributes_for :star_rating, :reject_if => lambda { |a| a[:value].blank? }, :allow_destroy => true
	
	def self.by_user_id(user_id)
		where(:user_id => user_id)
	end
end
