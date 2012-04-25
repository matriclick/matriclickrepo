class TipsController < ApplicationController
	before_filter :redirect_unless_admin, :except => [:index]
  # TIPS ACTIONS
  
  # GET
  def index
  	@ceremony_type = CeremonyType.find params[:ceremony_type_id]
    @tips = Tip.where(:ceremony_type_id => @ceremony_type.id)
  end
  
  # GET
  def new
  	@ceremony_type = CeremonyType.find params[:ceremony_type_id]
  	@ceremony_types = CeremonyType.all
  	@tip = Tip.new
  	@tip.ceremony_type_id = params[:ceremony_type]
  end
  
  # GET
  def edit
  	@ceremony_type = CeremonyType.find params[:ceremony_type_id]
  	@ceremony_types = CeremonyType.all
		@tip = Tip.find params[:id]
  end
  
  # POST
  def create
    @tip = Tip.new(params[:tip])
    @tip.ceremony_type_id = params[:ceremony_type_id]
	
    respond_to do |format|
      if @tip.save
      
        format.html { redirect_to ceremony_type_tips_url(@tip.ceremony_type_id), notice: 'Tip was successfully created.' }
        format.json { render json: @ceremony, status: :created, location: @tip }
      else
      	@ceremony_type = CeremonyType.find params[:ceremony_type_id]
      	@ceremony_types = CeremonyType.all
        format.html { render action: :new } #this throws error if select is nill
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT
  def update
    @tip = Tip.find params[:id]
		
    respond_to do |format|
      if @tip.update_attributes(params[:tip])
        format.html { redirect_to ceremony_type_tips_url(@tip.ceremony_type_id), notice: 'Tip was successfully updated.' }
        format.json { head :ok }
      else
      	@ceremony_type = CeremonyType.find params[:ceremony_type_id]
      	@ceremony_types = CeremonyType.all
        format.html { render action: :edit, :ceremony_type => @tip.ceremony_type_id }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to ceremony_type_tips_url(@tip.ceremony_type_id) }
      format.json { head :ok }
    end
  end
  
	private
	def redirect_unless_admin
		if user_signed_in?
			redirect_to ceremony_type_tips_url unless current_user.role_id == 1
		else
			redirect_to ceremony_type_tips_url
		end
	end
end
