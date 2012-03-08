class PostsController < ApplicationController
  before_filter :authorize, :load_config
  
  def index
    @posts = Post.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  
  def load_config
    Post.load_config
    Post.load_path
  end
end
