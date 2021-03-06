require 'spec_helper'

describe PagesController do
  render_views
  
  before (:each) do
    @title = "Ruby test app | "
  end
  
  describe "GET 'home'" do
    
    describe "when not signed in " do
      it "should be successful" do
        get 'home'
        response.should be_success
      end
    
      it "should have the correct title" do
        get 'home'
        response.should have_selector("title", :content => @title + "Home")
      end
    end
    describe "when signed in" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @other_user = Factory(:user,:email => Factory.next(:email))
        @other_user.follow!(@user)
      end
      
      it "should have the correct following / follower counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user), :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user), :content => "1 follower")
      end
      
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title", :content => @title + "Contact")
    end 
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the correct title" do
      get 'about'
      response.should have_selector("title", :content => @title + "About")
    end
  end
  
  describe "GET 'help'" do
    it "it should be successful" do
      get 'help'
      response.should be_success
    end
    it "should have the correct title" do
      get 'help'
      response.should have_selector("title", :content => @title + "Help")
    end
  end
end
