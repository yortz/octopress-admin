class PostsController < ApplicationController
  before_filter :authorize
  
  def index
    @posts = Post.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.valid?
        @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.valid?
        @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  def generate_site
    Post.delay.generate_site
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Generating website.' }
      format.json { head :no_content }
    end
  end
  
  
end
