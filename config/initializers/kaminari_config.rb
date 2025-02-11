# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 24 # Gallery grid layout works well with multiples of 6
  config.max_per_page = 48
  config.window = 2
  config.outer_window = 1
  config.left = 1
  config.right = 1
end
