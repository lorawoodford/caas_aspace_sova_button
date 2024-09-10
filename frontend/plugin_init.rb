module ApplicationHelper
  require_relative 'helpers/toolbar_helper.rb'
end

# If the sova_url has not been set in config.rb, fallback to the production URL.
Rails.application.config.after_initialize do
  if !AppConfig.has_key?(:sova_url)
    AppConfig[:sova_url] = 'https://sova.si.edu'
  end
end
