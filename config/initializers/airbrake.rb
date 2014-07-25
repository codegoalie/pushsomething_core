Airbrake.configure do |config|
  config.api_key = 'c5abef747faf83ebe799e804c215ed8b'

# Airbrake error catching for Sidekiq workers
Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new do |ex, ctx_hash|
    Airbrake.notify(ex, ctx_hash)
  end
end
