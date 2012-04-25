class HomeController < ApplicationController
	before_filter :load_user_tools_menu, :except => [:login, :tour]
	before_filter :hide_left_menu, :except => [:login, :index]
	
	def index
	end
	
	def login
	end
	
	def tour
	end
	
	def terms
	  respond_to do |format| 
      format.html # terms.html.erb
    end  
	end
	
	def company
	  respond_to do |format| 
      format.html # company.html.erb
    end  
	end
	
	def faq
	  respond_to do |format| 
      format.html # faq.html.erb
    end  
	end
	
	def criteria
	  respond_to do |format| 
      format.html # criteria.html.erb
    end  
	end
	
	def como_nace
	  respond_to do |format| 
      format.html # como_nace.html.erb
    end  
	end
	
	def press
	  respond_to do |format| 
      format.html # press.html.erb
    end  
	end
	
	def work_with_us
	  respond_to do |format| 
      format.html # work_with_us.html.erb
    end  
	end
	
	private
	def hide_left_menu
	 @hide_left_menu = true
	end
end
