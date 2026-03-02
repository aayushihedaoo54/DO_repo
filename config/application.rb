require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module DistributedOrchestratror
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_job.queue_adapter = :sidekiq
    config.api_only = true
  end
end
