# frozen_string_literal: true

module Rails
  module Rack
    class Logger < ActiveSupport::LogSubscriber
      # rubocop:disable Style/FormatStringToken
      def started_request_message(request)
        format(
          'Started %s "%s" for %s at %s',
          request.request_method,
          request.filtered_path,
          anonymized_ip(request),
          Time.current.to_default_s
        )
      end
      # rubocop:enable Style/FormatStringToken

      def anonymized_ip(request)
        ip = IPAddr.new(request.ip)

        if ip.ipv4?
          ip.mask(24).to_s
        else
          ip.mask(48).to_s
        end
      end
    end
  end
end
