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
    @user.stub!(:new_record?).and_return(true)
    @user.activated?.should == false
  end

  it "should mark all new users as not active" do
    @user.stub!(:new_record?).and_return(true)
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

  it "should be a SHA1 hex digest key" do
    Digest::SHA1.should_receive(:hexdigest).with(any_args()).and_return("some_hex_value")
    Utilisateur.make_key.should eql("some_hex_value")
  end

  it "should use current date and time as base for key" do
    now = Time.now
    Time.should_receive(:now).twice.and_return(now)
    Utilisateur.make_key
  end

  def make_activation_code
    self.activation_code = self.class.make_key
  end

  it "should set the activation_code to the generated key" do
    Utilisateur.should_receive(:make_key).and_return("the generated (activation) key")
    user = Utilisateur.new(user_attributes)
    user.should_receive(:activation_code=).with("the generated (activation) key")
    user.make_activation_code
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
    @user = Utilisateur.new(user_attributes)
    @user.stub!(:new_record?).and_return(false)
    @user.stub!(:reload)
    @user.stub!(:save)
    @user.stub!(:send_activation_notification)
  end

  after(:each) do
    Utilisateur.all.destroy!
  end

  it "should mark users as activated" do
    @user.make_activation_code
    @user.activated?.should == false
    @user.activate
    @user.activated?.should == true
  end

  it "should mark users as active" do
    @user.make_activation_code
    @user.activated?.should == false
    @user.activate
    @user.active?.should == true
  end

  it "should get latest user properties from database if user already exists" do
    @user.should_receive(:reload)
    @user.activate
  end

  it "should mark user as (just) activated" do
    @user.activate
    @user.recently_activated?.should == true
  end

  it "should set the activated_at property to the current date and time" do
    now = DateTime.now
    DateTime.should_receive(:now).and_return(now)
    @user.should_receive(:activated_at=).with(now)
    @user.activate
  end

  it "should clear out the activation code" do
    @user.should_receive(:activation_code=).with(nil)
    @user.activate
  end

  it "should save the updated user model to the database" do
    @user.should_receive(:save)
    @user.activate
  end

  it "should send out the activation notification" do
    @user.should_receive(:send_activation_notification)
    @user.activate
  end

end
