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
end
 