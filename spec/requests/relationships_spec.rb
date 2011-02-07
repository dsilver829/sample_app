require 'spec_helper'

describe "Relationships" do

   before(:each) do
    @user = Factory(:user)
    @other_user = Factory(:user, :email => Factory.next(:email))
    visit signin_path
    fill_in :email,     :with => @user.email
    fill_in :password,  :with => @user.password
    click_button
  end

  describe "creation" do

    describe "follow" do
      it "should make a new relationship" do
        lambda do
          visit user_path(@other_user)
          click_button
          response.should have_selector("a",
                                        :href => followers_user_path(@other_user),
                                        :content => "1 follower")
        end.should change(@user.following, :count).by(1)
      end
    end

    describe "unfollow" do
      it "should destroy a relationship" do
        lambda do
          visit user_path(@other_user)
          click_button
        end.should change(@user.following, :count).by(1)
        lambda do
          visit user_path(@other_user)
          click_button
          response.should have_selector("a",
                                        :href => followers_user_path(@other_user),
                                        :content => "0 followers")
        end.should change(@user.following, :count).by(-1)
      end
    end

  end

end
