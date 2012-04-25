# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: "no-reply@matriclick.cl"
  
  def user_email(user, password) # when a UserAccount add a new user to his people
  	@user = user
		@password = password
  	mail to: "<#{@user.email}>", bcc: "soporte@redvel.cl", subject: "[Matriclick.com] Se ha creado un nuevo usuario"
  end
  
	#DRESS REQUEST
	def dress_request_to_seller_email(dress, user)
		@dress = dress
		@user = user
		if @dress.independent
			mail to: "#{@dress.seller_email}", bcc: %w{carolina.gaete@matriclick.com soporte@redvel.cl}, subject: "[Matriclick.com] Cotización de Vestido"
		else
			mail to: "carolina.gaete@matriclick.com", bcc: "soporte@redvel.cl", subject: "[Matriclick.com] Cotización de vestido (no independiente) por #{@user.email}"
		end
	end
	
	def dress_request_to_buyer_email(dress, user)
		@dress = dress
		@user = user
		if @dress.independent
			mail to: "#{@user.email}", bcc: %w{carolina.gaete@matriclick.com soporte@redvel.cl}, subject: "[Matriclick.com] Cotización de Vestido"
		end
	end

	# SUELTA LA ROCA
	def rock_email(rock, to_sender = false)
		@rock = rock
		if to_sender
			mail to: @rock.sender_email, subject: "[Matriclick.com] Has enviado esta postal a #{@rock.recipient_name} (#{@rock.recipient_email})"
		else
			mail to: "#{@rock.recipient_name} <#{@rock.recipient_email}>", from: "#{@rock.sender_name} <no-reply@matriclick.com>", reply_to: "#{@rock.sender_email}", subject: "[Matriclick.com] Una postal de #{@rock.sender_name}"
		end		
	end

  # BOOKINGS
  def booking_confirmation_email(booking)
  	@booking = booking
  	@bookable = @booking.bookable
  	@supplier_account = @booking.supplier_account
  	mail to: "<#{@booking.user_account.users.first.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Tu reserva por '#{@bookable.name}' ha sido confirmada"
  end
  
  def booking_deletion_email(booking)
  	@booking = booking
  	@bookable = @booking.bookable
  	@supplier_account = @booking.supplier_account
  	mail to: "<#{@booking.user_account.users.first.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Tu reserva por '#{@bookable.name}' ha sido cancelada"
  end
  
	def booking_resources_full_email(booking)
		@booking = booking
		@bookable = @booking.bookable
		@supplier_account = @booking.supplier_account
		mail to: "<#{@booking.user_account.users.first.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Tu reserva por '#{@bookable.name}' no podrá ser confirmada"
	end

	def booking_expired_email(booking)
		@booking = booking
		@bookable = @booking.bookable
		@supplier_account = @booking.supplier_account
		mail to: "<#{@booking.user_account.users.first.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Tu reserva por '#{@bookable.name}' ha expirado"
	end
    
  #CONVERSATIONS
  # a supplier respond to a message
  def supplier_respond_message_email(message, user) #Cant get the user_email from message
  	@message = message
  	@conversation = @message.conversation
  	@user = user
  	@supplier_account = @conversation.supplier_account
  	mail to: "<#{@user.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] El proveedor #{@supplier_account.fantasy_name} ha respondido a tu mensaje"
  end
  
	# REMINDERS
  def reminder_email(activity_reminder)
   	@activity_reminder = activity_reminder
 		mail to: "<#{@activity_reminder.mail}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Recordatorio de Actividad en Checklist."
  end

	def after_wedding_email(user_account)
		@user_account = user_account
		@supplier_accounts = SupplierAccount.user_reviewable(@user_account)
		mail to: "<#{@user_account.users.first.email}>", bcc: "matriclick_notice@matriclick.com ", subject: "[Matriclick.com] Estamos felices por ustedes"
	end
end
