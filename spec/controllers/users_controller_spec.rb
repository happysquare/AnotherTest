require 'spec_helper'

describe UsersController do 
  render_views
  before (:each) do
     @title = "Ruby test app | "
   end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have the correct title" do
      get 'new'
      response.should have_selector("title", :content => @title + "Sign Up")
    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user) 
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    it "should have the correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @title + "users | " + @user.name)
    end
    it "should have the correct user" do
      get 'show', :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the correct users name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a gravatar" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => 'gravatar') 
    end
  end
  describe "POST 'new'" do
    describe "failure" do
      before(:each) do
        @att = {:name => "",
                :email => "",
                :password => "",
                :password_confirmation => ""}
      end
      
      it "should fail to create a user without the correct parameters" do
        lambda do
          post :create, :user => @att
        end.should_not change(User, :count)
      end
      it "should stay on the new page when there is a failed submission" do
        post :create ,:user => @att
        response.should have_selector("title", :content => "Sign Up")
      end
    
      it "should render the correct template" do
        post :create, :user => @att
        response.should render_template('new')
      end
    end
  end
  
end
 