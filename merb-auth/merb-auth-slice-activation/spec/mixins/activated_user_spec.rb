require File.dirname(__FILE__) + '/../spec_helper'
require 'dm-core'
require 'dm-validations'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "..","lib", "merb-auth-slice-activation", "mixins", "activated_user")


module ActivatedUserSpecHelper
  def user_attributes(options = {})
    { :login => 'fred',
      :email => 'fred@example.com'
    }.merge(options)
  end
end


describe "Actviated User" do
  before(:all) do
    Merb::Router.prepare { add_slice(:merb_auth_slice_activation)} 
  end
  
  after(:all) do
    Merb::Router.reset!
  end
  
  describe "ActivatedUser Mixin" do

    include ActivatedUserSpecHelper

    before(:all) do
      DataMapper.setup(:default, "sqlite3::memory:")

      class Utilisateur
        include DataMapper::Resource
        include Authentication::Mixins::ActivatedUser

        property :id,    Serial
        property :email, String
        property :login, String

      end
      Utilisateur.auto_migrate!
    end

    before(:each) do
      @user = Utilisateur.new(user_attributes)
    end

    after(:each) do
      Utilisateur.all.destroy!
    end

    it "should add the 'activated_at' property to the user model" do
      @user.should respond_to(:activated_at)
      @user.should respond_to(:activated_at=)
    end

    it "should add the 'activation_code' property to the user model" do
      @user.should respond_to(:activation_code)
      @user.should respond_to(:activation_code=)
    end

    it "should mark all new users as not activated" do
      @user.activated?.should == false
    end

    it "should mark all new users as not active" do
      @user.active?.should == false
    end

  end


  describe "ActivatedUser Mixin Activation Code" do

    include ActivatedUserSpecHelper

    before(:all) do
      DataMapper.setup(:default, "sqlite3::memory:")

      class Utilisateur
        include DataMapper::Resource
        include Authentication::Mixins::ActivatedUser

        property :id,    Serial
        property :email, String
        property :login, String
      end
      Utilisateur.auto_migrate!
    end

    after(:each) do
      Utilisateur.all.destroy!
    end
  
    before(:each) do
      @user = Utilisateur.new(user_attributes)
    end

    it "should set the activation_code" do
      @user.activation_code.should be_nil
      @user.save
      @user.activation_code.should_not be_nil
    end
  end


  describe "Activation" do

    include ActivatedUserSpecHelper

    before(:all) do
      DataMapper.setup(:default, "sqlite3::memory:")

      class Utilisateur
        include DataMapper::Resource
        include Authentication::Mixins::ActivatedUser

        property :id,    Serial
        property :email, String
        property :login, String
      end
      Utilisateur.auto_migrate!
    end

    before(:each) do
      Utilisateur.all.destroy!
      @user = Utilisateur.create(user_attributes)
    end

    after(:each) do
      Utilisateur.all.destroy!
    end

    it "should mark users as active" do
      @user.should_not be_active
      @user.activate
      @user.should be_active
      @user.reload
      @user.should be_active
    end

    it "should mark user as (just) activated" do
      @user.activate
      @user.should be_recently_activated
    end

    it "should set the activated_at property to the current date and time" do
      now = DateTime.now
      DateTime.should_receive(:now).and_return(now)
      @user.activate
      @user.activated_at.should == now
    end

    it "should clear out the activation code" do
      @user.activation_code.should_not be_nil
      @user.activate
      @user.activation_code.should be_nil
    end

    it "should send out the activation notification" do
      @user.should_receive(:send_activation_notification)
      @user.activate
    end

  end
end