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
end
 