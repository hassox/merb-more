require 'rubygems'
require 'merb-core'
require 'merb-slices'
require 'spec'

# Add merb-auth-slice-activation.rb to the search path
Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path]   = File.join(File.dirname(__FILE__), '..', 'lib', 'merb-auth-slice-activation.rb')

# Using Merb.root below makes sure that the correct root is set for
# - testing standalone, without being installed as a gem and no host application
# - testing from within the host application; its root will be used
Merb.start_environment(
  :testing => true, 
  :adapter => 'runner', 
  :environment => ENV['MERB_ENV'] || 'test',
  :merb_root => Merb.root,
  :session_store => 'memory'
)

# Setup the required configuration for the slice
Merb::Slices::config[:merb_auth_slice_activation][:from_email]        = "homer@example.com"
Merb::Slices::config[:merb_auth_slice_activation][:activation_host]   = "example.com"

module Merb
  module Test
    module SliceHelper
      
      # The absolute path to the current slice
      def current_slice_root
        @current_slice_root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end
      
      # Whether the specs are being run from a host application or standalone
      def standalone?
        Merb.root == ::MerbAuthSliceActivation.root
      end
      
    end
  end
end

class Merb::Mailer
  self.delivery_method = :test_send
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(Merb::Test::SliceHelper)
end