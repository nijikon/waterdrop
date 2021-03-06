# frozen_string_literal: true

# WaterDrop library
module WaterDrop
  # Sync producer for messages
  class SyncProducer < BaseProducer
    # Performs message delivery using deliver_async method
    # @param message [String] message that we want to send to Kafka
    # @param options [Hash] options (including topic) for producer
    # @raise [WaterDrop::Errors::InvalidMessageOptions] raised when message options are
    #   somehow invalid and we cannot perform delivery because of that
    def self.call(message, options)
      attempts ||= 0
      attempts += 1

      validate!(options)
      return unless WaterDrop.config.deliver
      DeliveryBoy.deliver(message, options)
    rescue Kafka::Error => e
      if attempts > WaterDrop.config.kafka.max_retries
        WaterDrop.logger.error e
        raise e
      else
        WaterDrop.logger.warn "Retrying delivery after: #{e}"
        retry
      end
    end
  end
end
