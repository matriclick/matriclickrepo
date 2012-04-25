class DressesController < ApplicationController
	before_filter :redirect_unless_admin, :except => [:menu, :index, :show, :dress_request, :notify_request]
	before_filter :authenticate_guest, :only => [:menu, :index, :show]
	
	def menu
	end
	
  # GET /dresses
  # GET /dresses.json
  def index
    @dresses = Dress.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dresses }
    end
  end

  # GET /dresses/1
  # GET /dresses/1.json
  def show
    @dress = Dress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dress }
    end
  end

  # GET /dresses/new
  # GET /dresses/new.json
  def new
    @dress = Dress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dress }
    end
  end

  # GET /dresses/1/edit
  def edit
    @dress = Dress.find(params[:id])
  end

  # POST /dresses
  # POST /dresses.json
  def create
    @dress = Dress.new(params[:dress])

    respond_to do |format|
      if @dress.save
        format.html { redirect_to @dress, notice: 'Dress was successfully created.' }
        format.json { render json: @dress, status: :created, location: @dress }
      else
        format.html { render action: "new" }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dresses/1
  # PUT /dresses/1.json
  def update
    @dress = Dress.find(params[:id])

    respond_to do |format|
      if @dress.update_attributes(params[:dress])
        format.html { redirect_to @dress, notice: 'Dress was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dresses/1
  # DELETE /dresses/1.json
  def destroy
    @dress = Dress.find(params[:id])
    @dress.destroy

    respond_to do |format|
      format.html { redirect_to dresses_url }
      format.json { head :ok }
    end
  end

	def dress_request
		@dress = Dress.find params[:id]
		
		respond_to do |format|
			format.html {render :layout => false}
		end
	end
	
	def notify_request
		@dress = Dress.find params[:id]
		@user = current_user
		
		if @dress.present? and @user.present?
			UserMailer.dress_request_to_seller_email(@dress, @user).deliver
			UserMailer.dress_request_to_buyer_email(@dress, @user).deliver
		end
		
		redirect_to @dress
	end
end
