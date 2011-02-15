require 'spec_helper'

describe MicropostsController do
  render_views
  describe "access" do
    it "should deny access to create" do
      post :create
      response.should redirect_to(signin_path)
    end
    it "should deny access to destroy" do
      post :destroy, :id=> 1
      response.should redirect_to(signin_path)
    end
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
      @mp1= Factory(:micropost, :user => @user)
      wrong_user = Factory(:user, :email => Factory.next(:email))
      test_sign_in(wrong_user)
    end
    
    it "should deny access" do
      delete :destroy, :id => @mp1
      response.should redirect_to(root_path)
    end
    
    describe "for authorised users" do
      before(:each) do
        test_sign_in(@user)
        
      end
      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id=> @mp1
        end.should change(Micropost,:count).by(-1)
      end
    end
  
    
  end
  describe "create" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @att = {:content => "test post"}
    end
    describe "failure" do
      it "should not create a post with no content" do
         @att[:content] = ""
        lambda do
          post :create, :micropost => @att
        end.should_not change(Micropost, :count)
      end
      it " should redrect to the home page" do
        @att[:content] = ""
        post :create, :micropost => @att
        response.should render_template('pages/home')
      end
    end
    describe "success" do
      it "should create a post" do
        lambda do
          post :create, :micropost => @att
        end.should change(Micropost, :count).by(1)
      end
      
      it "should redirect to the home page" do
        post :create, :micropost => @att
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message confirming the creation" do
        post :create, :micropost => @att
        flash[:success].should =~ /Your post was successful/
      end
    end
  end
end
