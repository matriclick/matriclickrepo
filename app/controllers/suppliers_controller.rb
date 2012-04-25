class SuppliersController < ApplicationController
	before_filter :authenticate_supplier!
	before_filter :set_supplier_language
  private
  #This set the session language when a supplier is created
  
	def set_supplier_language
    I18n.locale = current_supplier.language if supplier_signed_in?
  end
  
end
