require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectFIREBALL
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # allow ephemeral jobs in the bg w/o 3rd party (e.g. resque/sidekiq)
    config.active_job.queue_adapter = :async
    config.autoload_paths << Rails.root.join('lib')
  end
end
