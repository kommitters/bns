# frozen_string_literal: true

module Domain
  ##
  # The Domain::SupportEmail class provides a domain-specific representation of an SupporEmail object.
  # It encapsulates information about a support email, including the subject, the sender, and the date.
  #
  class SupportEmail
    attr_reader :subject, :sender
    attr_accessor :date

    ATTRIBUTES = %w[subject sender date].freeze

    # Initializes a Domain::SupportEmail instance with the specified subject, sender, and date.
    #
    # <br>
    # <b>Params:</b>
    # * <tt>String</tt> eamil subject.
    # * <tt>String</tt> Email of the sender.
    # * <tt>String</tt> Reception date
    #
    def initialize(subject, sender, date)
      @subject = subject
      @sender = sender
      @date = parse_to_datetime(date)
    end

    private

    def parse_to_datetime(date)
      DateTime.parse(date).to_time
    end
  end
end
