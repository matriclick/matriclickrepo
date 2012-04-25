class ContactsController < ApplicationController

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.json { render json: @contact }
    end
  end
  
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to company_path(), notice: 'Contacto fue enviado exitosamente!.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
end
