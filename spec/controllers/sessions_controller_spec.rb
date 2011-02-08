require 'spec_helper'

describe SessionsController do
  render_views
  before(:each) do
     @title = "Ruby test app | "
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should should have the correct page title" do
      get :new
      response.should have_selector("title",:content => @title + "Sign in")
    end
  end
   
  describe "POST 'create'" do
    describe "invalid sign in" do
      before(:each) do
        @att = {:email => 'james@happysquare.com.au', :password => 'invalid_password'}
      end
      
      it "should render the new template" do
        post :create, :session => @att
        response.should  render_template 'new'
      end
      
      it "should have the right title " do
        post :create, :session => @att
        response.should have_selector("title",:content => "Sign in")
      end
      
      it "should have a flash error message" do
        post :create, :session => @att
        flash.now[:error].should =~ /invalid/i
      end
      
    end
    
    describe "valid sign in" do
      before(:each) do
        @user = Factory(:user)
        @att = {:email => @user.email, :password => @user.password}
      end
      
      it "should sign the user in" do
        post 'create', :session => @att
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user page" do
        post 'create', :session => @att
        response.should redirect_to(user_path(@user))
      end
    
    end
    
  end
  
  describe "DELETE 'destroy'" do
    it "should sign the user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end 
  
  

end
