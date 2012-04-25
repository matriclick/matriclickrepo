class Conversation < ActiveRecord::Base
	belongs_to :user
	belongs_to :supplier_account
	belongs_to :conversable, :polymorphic => true
	has_many :messages, :dependent => :destroy
	
	accepts_nested_attributes_for :messages, :reject_if => proc { |a| a[:content].blank? }, :allow_destroy => true
	
	def self.by_user(user)
		where(:user_id => user.id)
	end

	def count_of_supplier_unread_messages
		self.messages.supplier_unread.count
	end
	
	def count_of_user_unread_messages
		self.messages.user_unread.count
	end
end
