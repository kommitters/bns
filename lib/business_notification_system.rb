# frozen_string_literal: true

require_relative "business_notification_system/version"
require_relative "business_notification_system/use_cases/birthday_notifier"

module BusinessNotificationSystem
  class Error < StandardError; end
  # Your code goes here...
  use_case = BirthdayNotifier.new
end
