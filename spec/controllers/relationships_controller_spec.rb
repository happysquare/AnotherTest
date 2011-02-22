require 'spec_helper'

describe RelationshipsController do
  describe "when not signed in" do
    it "should require signin to create" do
      post :create
      response.should redirect_to(signin_path)
    end
    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
      test_sign_in(@user)
    end
    
    it "should create a relationship" do
      lambda do
        post :create, :relationship => {:followed_id => @followed }
        response.should be_redirect
      end.should change(Relationship,:count).by(1)
    end
    it "should create a relationship using AJAX" do
      lambda do
        xhr :post, :create, :relationship => {:followed_id => @followed }
        response.should be_success
      end.should change(Relationship,:count).by(1)
    end
   
    before(:each) do
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end
    it "should destroy a relationship" do  
      lambda do
        delete :destroy, :id => @relationship
        response.should be_redirect
      end.should change(Relationship,:count).by(-1)
    end
    
    it "should destroy a relationship using JS" do  
      lambda do
        xhr :delete, :destroy, :id => @relationship
        response.should be_success
      end.should change(Relationship,:count).by(-1)
    end
  end
end
