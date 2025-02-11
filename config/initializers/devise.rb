# frozen_string_literal: true

Devise.setup do |config|
  # ==> Controller configuration
  config.parent_controller = 'ActionController::Base'

  # ==> Mailer Configuration
  config.mailer_sender = 'noreply@example.com'
  config.mailer = 'Devise::Mailer'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Authentication Keys
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 12
  
  # ==> Configuration for :rememberable
  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true

  # ==> Navigation configuration
  config.sign_out_via = [:delete, :get] # Allow both DELETE and GET for sign out

  # ==> Security Extension
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.timeout_in = 30.minutes
  config.lock_strategy = :failed_attempts
  config.maximum_attempts = 20
  config.last_attempt_warning = true
end
