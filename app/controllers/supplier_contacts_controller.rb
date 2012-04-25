class SupplierContactsController < ApplicationController
	before_filter :authenticate_supplier!, :set_supplier_layout, :find_supplier
  # GET /supplier_contacts
  # GET /supplier_contacts.json
  def index
    @supplier_contacts = @supplier.supplier_account.supplier_contacts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supplier_contacts }
    end
  end

  # GET /supplier_contacts/new
  # GET /supplier_contacts/new.json
  def new
		@supplier_account = current_supplier.supplier_account
    @supplier_contact = @supplier_account.supplier_contacts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supplier_contact }
    end
  end

  # GET /supplier_contacts/1/edit
  def edit
		@supplier_account = @supplier.supplier_account
    @supplier_contact = SupplierContact.find(params[:id])
  end

  # POST /supplier_contacts
  def create
		@supplier_account = @supplier.supplier_account
    @supplier_contact = @supplier_account.supplier_contacts.build params[:supplier_contact]

    respond_to do |format|
      if @supplier_contact.save
        format.html { redirect_to supplier_account_supplier_contacts_url, :notice => "#{t('activerecord.successful.messages.created', :model =>  @supplier_contact.class.model_name.human)}" }
      else
        @supplier_account = current_supplier.supplier_account
        format.html { render action: "new" }
      end
    end
  end

  # PUT /supplier_contacts/1
  def update
    @supplier_contact = SupplierContact.find(params[:id])

    respond_to do |format|
      if @supplier_contact.update_attributes(params[:supplier_contact])
        format.html { redirect_to supplier_account_supplier_contacts_url, :notice => "#{t('activerecord.successful.messages.updated', :model =>  @supplier_contact.class.model_name.human)}" }
      else
        @supplier_account = @supplier.supplier_account
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /supplier_contacts/1
  def destroy
    @supplier_contact = SupplierContact.find(params[:id])
    @supplier_contact.destroy

    respond_to do |format|
      format.html { redirect_to supplier_account_supplier_contacts_url(@supplier) }
    end
  end
end
