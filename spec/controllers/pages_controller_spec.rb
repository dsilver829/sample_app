require 'spec_helper'

describe PagesController do
  render_views 

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the correct title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Home")
    end

    describe "signed-in user" do

      describe "sidebar" do

        before(:each) do
          @user = test_sign_in(Factory(:user))
          @mp1 = Factory(:micropost, :user => @user)
        end

        it "should display the correct number of microposts" do
          get 'home'
          response.should have_selector("span",
                                        :class => "microposts",
                                        :content => "1")
        end

        it "should display pluralization correctly" do
          get 'home'
          response.should have_selector("span",
                                        :class => "microposts",
                                        :content => "1 micropost")
          @mp2 = Factory(:micropost, :user => @user)
          get 'home'
          response.should have_selector("span",
                                        :class => "microposts",
                                        :content => "2 microposts")
          @mp1.destroy
          @mp2.destroy
          get 'home'
          response.should have_selector("span",
                                        :class => "microposts",
                                        :content => "0 microposts")
        end

      end

      describe "feed" do

        before(:each) do
          @user = test_sign_in(factory())
        end

        it "should paginate microposts" do
          @microposts = @user.microposts
          50.times do
            @microposts << Factory(:micropost, :user => @user,
                                   :content => Factory.next(:content))
          end
          get 'home'
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector(  "a", :href => "/?page=2",
                                         :content => "2")
          response.should have_selector(  "a", :href => "/?page=2",
                                         :content => "Next")
        end
        
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
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the correct title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the correct title" do
      get 'help'
      response.should have_selector("title",
      :content => "Ruby on Rails Tutorial Sample App | Help")
    end
  end

end