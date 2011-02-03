class UsersController < ApplicationController
  
  
  def new
    @title = "Sign Up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the sample app"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def show
    
    @user = User.find(params[:id])
    @name = @user.name
    @title = "users | " + @name
    
  end
  
end
