# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#

require 'rails_helper'
RSpec.describe User, type: :model do
  subject(:user){ User.new(username: 'Bradley', password: 'password')}
  describe "Validations properly setup" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) } #login prior?
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe "Associates" do
    it { should have_many(:goals)}
    it { should have_many(:comments)}
  end

  describe "User#ensure_session_token" do
    it "makes a session_token" do
      expect(user.session_token).not_to be_nil
    end
  end

  describe "User#reset_session_token!" do
    it "changes the session_token" do 
      prior_session_token = user.session_token 
      user.reset_session_token!
      expect(user.session_token).not_to eq(prior_session_token)
    end
    it "does not set session_token to nil" do 
      user.reset_session_token!
      expect(user.session_token).not_to be_nil 
    end
  end

  describe "User#is_password?(password)" do
    it "verifies correct password" do 
      expect(user.is_password?('password')).to be true
    end
    it "rejects incorrect password" do 
      expect(user.is_password?('badpassword')).to be false
    end
  end

  describe "User#password=(password)" do
    it "correctly sets password_digest to given password argument" do 
      expect(BCrypt::Password).to receive(:create).with('password')
      User.new(username: "chuck", password: "password")
    end
  end

  describe "User::find_by_credentials" do
    it "finds a user that is in the database" do
      user2 = User.new(username: "chuck", password: "password")
      user2.save!
      expect(User.find_by_credentials(user2.username, user2.password)).to eq(user2)
    end
    it "doesn't find a user that is not in the database" do
      expect(User.find_by_credentials('', '')).to be_nil
    end
  end
end


