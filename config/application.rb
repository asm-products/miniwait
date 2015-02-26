require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppConfig
  class Application < Rails::Application
    
	config.app_name = 'MiniWait'
	# usage: <%= Rails.application.config.app_name %>
	
	config.domain_name = 'miniwait.com'
	# usage: <%= Rails.application.config.domain_name %>
	
  end
end