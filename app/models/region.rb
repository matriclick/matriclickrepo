class Region < ActiveRecord::Base
	has_many :communes
	has_many :addresses
end
