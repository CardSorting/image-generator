require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

# Set timeout for jobs
Sidekiq.default_job_options = {
  retry: 3,
  backtrace: true,
  timeout: 300 # 5 minutes timeout for image generation
}
