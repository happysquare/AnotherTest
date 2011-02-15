class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    
    user = User.authenticate_and_retrieve(params[:session][:email],
                             params[:session][:password])
    
    if user.nil? then
      flash.now[:error] = "Invalid login"
      @title = "Sign in"
      render 'new' 
    else
      sign_in user
       redirect_back_or user 
    end
      
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  
  
  
end
