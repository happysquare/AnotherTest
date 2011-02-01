class UsersController < ApplicationController
  
  
  def new
    @title = "Sign Up"
  end
  
  def show
    
    @user = User.find(params[:id])
    @name = @user.name
    @title = "users | " + @name
    
  end
  
end
