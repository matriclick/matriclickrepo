# coding: utf-8
class SupplierMailer < ActionMailer::Base
  default from: "no-reply@matriclick.cl"
  
  def welcome_email(supplier)
  	@supplier = supplier
  	attachments.inline['firma_matriclick.jpg'] = File.read("#{Rails.root}/app/assets/images/firma_matriclick.jpg")
  	mail to: "<#{@supplier.email}>", bcc: "carolina.gaete@matriclick.com", subject: "[Matriclick.com] Bienvenido a la comunidad Matriclick"
  end
  
  # BOOKINGS
  def new_booking_email(booking)
  	@booking = booking
  	@supplier_account = @booking.supplier_account
  	@bookable = @booking.bookable
  	mail to: "<#{@supplier_account.supplier.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Han reservado '#{@bookable.name}'"
  end
  
  def booking_deletion_email(booking)
  	@booking = booking
  	@supplier_account = @booking.supplier_account
  	@bookable = @booking.bookable
  	mail to: "<#{@supplier_account.supplier.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Han cancelado la reserva por '#{@bookable.name}'"
  end
  
  #CONVERSATIONS
  # when a user respond a message conversation
  def message_email_to_supplier(message, user)
  	@message = message
  	@user = user
		@conversation = @message.conversation
		@supplier_account = @message.conversation.supplier_account 
  	@email_to = @supplier_account.supplier.email
  	mail to: @email_to, bcc: "carolina.gaete@matriclick.com", subject: "[Matriclick.com] ¡Has recibido un mensaje!"
  end
end
