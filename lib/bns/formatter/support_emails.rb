# frozen_string_literal: true

require_relative "../domain/support_email"
require_relative "./exceptions/invalid_data"
require_relative "./base"

module Formatter
  ##
  # This class implements methods from the Formatter::Base module, tailored to format the
  # Domain::SupportEmail structure for a dispatcher.
  class SupportEmails < Base
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

      support_emails_list.reduce("") do |payload, support_email|
        payload + build_template(Domain::SupportEmail::ATTRIBUTES, support_email)
      end
    end
  end
end
