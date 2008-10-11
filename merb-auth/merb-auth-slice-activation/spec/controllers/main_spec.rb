require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbAuthSliceActivation::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceActivation) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbAuthSliceActivation::Main, :index)
    controller.slice.should == MerbAuthSliceActivation
    controller.slice.should == MerbAuthSliceActivation::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbAuthSliceActivation::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbAuthSliceActivation')
  end
  
  it "should work with the default route" do
    controller = get("/merb-auth-slice-activation/main/index")
    controller.should be_kind_of(MerbAuthSliceActivation::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/merb-auth-slice-activation/index.html")
    controller.should be_kind_of(MerbAuthSliceActivation::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbAuthSliceActivation::Main, 'index')
    
    url = controller.url(:merb_auth_slice_activation_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/merb-auth-slice-activation/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:merb_auth_slice_activation_index, :format => 'html')
    url.should == "/merb-auth-slice-activation/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:merb_auth_slice_activation_home)
    url.should == "/merb-auth-slice-activation/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAuthSliceActivation::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb-auth-slice-activation/images"
    controller.public_path_for(:javascript).should == "/slices/merb-auth-slice-activation/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-auth-slice-activation/stylesheets"
    
    controller.image_path.should == "/slices/merb-auth-slice-activation/images"
    controller.javascript_path.should == "/slices/merb-auth-slice-activation/javascripts"
    controller.stylesheet_path.should == "/slices/merb-auth-slice-activation/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbAuthSliceActivation::Main._template_root.should == MerbAuthSliceActivation.dir_for(:view)
    MerbAuthSliceActivation::Main._template_root.should == MerbAuthSliceActivation::Application._template_root
  end

end