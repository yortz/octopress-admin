class PostsController < ApplicationController
  before_filter :authorize, :load_config
  
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  private
  
  def load_config
    Post.load_config
    Post.load_path
  end
  
end
