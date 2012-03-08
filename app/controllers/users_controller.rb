class UsersController < ApplicationController
  
  def new
    @user = User.new(params[:user])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
      flash[:notice] =  "Thank you for signing up!"
    else
      render "new"
    end
  end
  
end
