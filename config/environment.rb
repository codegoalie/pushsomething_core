# Load the rails application
require File.expand_path('../application', __FILE__)

# LogEntries configuration
if Rails.env.production?
  Rails.logger = Le.new('4988322a-eca9-47cd-b82d-a903e90b9a74',
                        log_level: Logger::INFO)
end

# Initialize the rails application
PushRails::Application.initialize!
