class Commune < ActiveRecord::Base
	belongs_to :region
	has_many :addresses
end
