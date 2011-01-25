require 'spec_helper'

describe PagesController do
  render_views
  
  before (:each) do
    @title = "Ruby test app | "
  end
  
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the create title" do
      get 'home'
      response.should have_selector("title", :content => @title + "Home")
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
