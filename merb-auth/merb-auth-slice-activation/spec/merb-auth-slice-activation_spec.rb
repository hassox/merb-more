require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthSliceActivation (module)" do

  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceActivation) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end

  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbAuthSliceActivation)
  end

  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[MerbAuthSliceActivation.name].should == current_slice_root
  end

  it "should have an :identifier property" do
    MerbAuthSliceActivation.identifier.should == "merb-auth-slice-activation"
  end

  it "should have an :identifier_sym property" do
    MerbAuthSliceActivation.identifier_sym.should == :merb_auth_slice_activation
  end

  it "should have a :root property" do
    MerbAuthSliceActivation.root.should == Merb::Slices.paths[MerbAuthSliceActivation.name]
    MerbAuthSliceActivation.root_path('app').should == current_slice_root / 'app'
  end

  it "should have a :file property" do
    MerbAuthSliceActivation.file.should == current_slice_root / 'lib' / 'merb-auth-slice-activation.rb'
  end

  it "should have metadata properties" do
    MerbAuthSliceActivation.description.should == "MerbAuthSliceActivation is a merb slice that adds basic activation for merb-auth-based merb applications."
    MerbAuthSliceActivation.version.should == "0.9.9"
    MerbAuthSliceActivation.author.should == "Daniel Neighman, Christian Kebekus"
  end

  # TODO fix spec
  # it "should have :routes and :named_routes properties" do
  #   MerbAuthSliceActivation.routes.should_not be_empty
  #   MerbAuthSliceActivation.named_routes[:activate].should be_kind_of(Merb::Router::Route)
  # end
  # 
  # it "should have an url helper method for slice-specific routes" do
  #   MerbAuthSliceActivation.url(:controller => 'activations', :action => 'activate', :activation_code => "012345abcdef").should == "/merb-auth-slice-activation/activate/012345abcdef"
  #   MerbAuthSliceActivation.url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  # end

  it "should have a config property (Hash)" do
    MerbAuthSliceActivation.config.should be_kind_of(Hash)
  end

  it "should have bracket accessors as shortcuts to the config" do
    MerbAuthSliceActivation[:foo] = 'bar'
    MerbAuthSliceActivation[:foo].should == 'bar'
    MerbAuthSliceActivation[:foo].should == MerbAuthSliceActivation.config[:foo]
  end

  it "should have a :layout config option set" do
    MerbAuthSliceActivation.config[:layout].should == :merb_auth_slice_activation
  end

  it "should have a dir_for method" do
    app_path = MerbAuthSliceActivation.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthSliceActivation.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthSliceActivation.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSliceActivation.dir_for(type).should == public_path / "#{type}s"
    end
  end

  it "should have a app_dir_for method" do
    root_path = MerbAuthSliceActivation.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'merb-auth-slice-activation'
    app_path = MerbAuthSliceActivation.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthSliceActivation.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthSliceActivation.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merb-auth-slice-activation'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSliceActivation.app_dir_for(type).should == public_path / "#{type}s"
    end
  end

  it "should have a public_dir_for method" do
    public_path = MerbAuthSliceActivation.public_dir_for(:public)
    public_path.should == '/slices' / 'merb-auth-slice-activation'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSliceActivation.public_dir_for(type).should == public_path / "#{type}s"
    end
  end

  it "should have a public_path_for method" do
    public_path = MerbAuthSliceActivation.public_dir_for(:public)
    MerbAuthSliceActivation.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSliceActivation.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end

  it "should have a app_path_for method" do
    MerbAuthSliceActivation.app_path_for("path", "to", "file").should == MerbAuthSliceActivation.app_dir_for(:root) / "path" / "to" / "file"
    MerbAuthSliceActivation.app_path_for(:controller, "path", "to", "file").should == MerbAuthSliceActivation.app_dir_for(:controller) / "path" / "to" / "file"
  end

  it "should have a slice_path_for method" do
    MerbAuthSliceActivation.slice_path_for("path", "to", "file").should == MerbAuthSliceActivation.dir_for(:root) / "path" / "to" / "file"
    MerbAuthSliceActivation.slice_path_for(:controller, "path", "to", "file").should == MerbAuthSliceActivation.dir_for(:controller) / "path" / "to" / "file"
  end

  it "should keep a list of path component types to use when copying files" do
    (MerbAuthSliceActivation.mirrored_components & MerbAuthSliceActivation.slice_paths.keys).length.should == MerbAuthSliceActivation.mirrored_components.length
  end

end
