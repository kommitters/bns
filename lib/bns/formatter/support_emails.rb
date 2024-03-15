# frozen_string_literal: true

require_relative "../domain/support_email"
require_relative "./exceptions/invalid_data"
require_relative "./base"

module Formatter
  ##
  # This class implements methods from the Formatter::Base module, tailored to format the
  # Domain::SupportEmail structure for a dispatcher.
  class SupportEmails < Base
    DEFAULT_TIME_ZONE = "+00:00"
    DEFAULT_FRECUENCY = 0

    # Initializes the Slack formatter with essential configuration parameters.
    #
    # <b>timezone</b> : expect an string with the time difference relative to the UTC. Example: "-05:00"
    def initialize(config = {})
      super(config)

      @timezone = config[:timezone] || DEFAULT_TIME_ZONE
      @frecuency = config[:frecuency]
    end

    # Implements the logic for building a formatted payload with the given template for support emails.
    #
    # <br>
    # <b>Params:</b>
    # * <tt>List<Domain::SupportEmail></tt> support_emails_list: list of support emails.
    #
    # <br>
    # <b>raises</b> <tt>Formatter::Exceptions::InvalidData</tt> when invalid data is provided.
    #
    # <br>
    # <b>returns</b> <tt>String</tt> payload: formatted payload suitable for a Dispatcher.
    #
    def format(support_emails_list)
      raise Formatter::Exceptions::InvalidData unless support_emails_list.all? do |support_email|
        support_email.is_a?(Domain::SupportEmail)
      end

      process_emails(support_emails_list).reduce("") do |payload, support_email|
        payload + build_template(Domain::SupportEmail::ATTRIBUTES, support_email)
      end
    end

    private

    def process_emails(emails)
      emails = update_timezone(emails)

      emails
    end

    def update_timezone(emails)
      emails.each { |email| email.date = set_timezone(email.date).strftime("%c") }
    end

    def set_timezone(date)
      date_time = DateTime.parse(date).to_time

      Time.at(date_time, in: @timezone)
    end
  end
end
