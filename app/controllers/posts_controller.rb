class PostsController < ApplicationController
  before_filter :redirect_unless_admin, :except => [:blog, :show]
	before_filter :authenticate_guest, :only => [:blog]
	before_filter :check_older_guests, :only => [:blog] # DZF check for older guest to destroy them

  def blog
    @posts = Post.page(params[:page]).order('created_at DESC').where(:industry_category_id => nil)
  end
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @blog_comment = @post.blog_comments.build
		

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    2.times { @post.post_images.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    2.times { @post.post_images.build }
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
		

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end
  
  def check_older_guests # DZF check for guests older than 1 week and destroy them
		begin
			UserAccount.joins(:users).where('users.role_id = 3 and created_at <= ? ', Time.now - 3.weeks).destroy_all
		rescue
			logger.info  "---------> ERROR WHEN clearing older guest users" 
		end
  end

	private
	def redirect_unless_admin
		if user_signed_in?
			redirect_to posts_url unless current_user.role_id == 1
		else
			redirect_to blog_url
		end
	end
end
