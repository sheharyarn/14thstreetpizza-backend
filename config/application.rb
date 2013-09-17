require File.expand_path('../boot', __FILE__)

# require 'rails/all'
# require "active_resource/railtie"
# require "sprockets/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module FourteenStreetPizza
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.exceptions_app = self.routes
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
