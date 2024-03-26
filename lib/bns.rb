# frozen_string_literal: true

require_relative "bns/version"
require_relative "bns/use_cases/use_cases"

module Bns # rubocop:disable Style/Documentation
  include UseCases
  class Error < StandardError; end

  warn "[DEPRECATION] This gem has been renamed to bas and will no\
  longer be supported. Please switch to bas as soon as possible."
end
