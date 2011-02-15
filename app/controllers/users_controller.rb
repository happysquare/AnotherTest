class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update,:index, :destroy]
  before_filter :check_correct_user, :only => [:edit,:update]
  def new
    @title = "Sign Up"
    @user = User.new
  end 
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    if(current_user.admin?) then
      @user = User.find(params[:id])
      name = @user.name
      @user.destroy
     
      redirect_to users_path , :notice => "The user \"#{name}\" has been deleted"
    else
      redirect_to root_path
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
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
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => Micropost.per_page)
    #@microposts = Micropost.paginate(:page => params[:page])
  end
  
  def edit
    @title = "Edit user"
    @change_image_url = "http://gravatar.com/emails"
  end
  
  def update
   if(@user.update_attributes(params[:user]))
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  private
    
    
    
    
    def check_correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
