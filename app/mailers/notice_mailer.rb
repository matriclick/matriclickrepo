# coding: utf-8
class NoticeMailer < ActionMailer::Base
	default from: "no-reply@matriclick.cl"
	
	#CONTACT
  def contact_email(contact)
  	@contact = contact
  	mail to: "carolina.gaete@matriclick.com", subject: "Contacto en Matriclick.com"
  end
  
  #FEEDBACK
  def feedback_email(feedback)
  	@feedback = feedback
  	mail to: "carolina.gaete@matriclick.com", bcc: "soporte@redvel.cl", subject: "Feedback en Matriclick.com"
  end
  
  #PRODUCT
  def product_email(product)
  	@product = product
  	mail to: "carolina.gaete@matriclick.com", subject: "Alerta Precio producto en Matriclick.com"
  end

  #SERVICE
  def service_email(service)
  	@service = service
  	mail to: "carolina.gaete@matriclick.com", subject: "Alerta Precio producto en Matriclick.com"
  end
  
  #REFERENCE
  def reference_request_email(reference_request)
  	@reference_request = reference_request
  	mail to: "carolina.gaete@matriclick.com", bcc: "soporte@redvel.cl", subject: "Referencias en Matriclick.com"
  end

	# MATRICLICK POINTS
	def matriclick_points_email(user, expense)
		@user = user
		@expense = expense
		mail to: "carolina.gaete@matriclick.com", bcc: %w(soporte@redvel.cl puntos@matriclick.com), subject: "Se registró un gasto para Puntos Matriclick"
	end
end
