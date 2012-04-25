class Address < ActiveRecord::Base
  has_one :invitee
	belongs_to :region
	belongs_to :commune
	has_one :groom
	has_one :bride
	accepts_nested_attributes_for :bride, :groom
	
	def get_address
		string_address = self.street.to_s+' '+self.number.to_s+(self.commune.blank? ? '': ', '+self.commune.name.to_s )
		return string_address
	end
end

