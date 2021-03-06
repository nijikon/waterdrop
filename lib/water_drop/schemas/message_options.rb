# frozen_string_literal: true

module WaterDrop
  module Schemas
    # Regexp to check that topic has a valid format
    TOPIC_REGEXP = /\A(\w|\-|\.)+\z/

    # Schema with validation rules for validating that all the message options that
    # we provide to producer ale valid and usable
    # @note Does not validate message itself as it is not our concern
    MessageOptions = Dry::Validation.Schema do
      required(:topic).filled(:str?, format?: TOPIC_REGEXP)
      optional(:key).maybe(:str?, :filled?)
      optional(:partition).filled(:int?, gteq?: 0)
      optional(:partition_key).maybe(:str?, :filled?)
    end
  end
end
