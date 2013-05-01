# Load the rails application
require File.expand_path('../application', __FILE__)

StoreEngine::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'baci.lindsaar.net',
    :user_name            => 'franks.monsterporium@gmail.com',
    :password             => 'bosschops',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
end

# Ensure the agent is started using Unicorn.
# This is needed when using Unicorn and preload_app is not set to true.
# See https://newrelic.com/docs/ruby/no-data-with-unicorn
if defined? Unicorn
  ::NewRelic::Agent.manual_start()
  ::NewRelic::Agent.after_fork(:force_reconnect => true)
end

# Initialize the rails application
StoreEngine::Application.initialize!
