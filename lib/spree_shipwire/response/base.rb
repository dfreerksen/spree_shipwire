module SpreeShipwire
  module Response
    class Base
      attr_reader :response, :json

      def initialize(response)
        @response = response
        @json = JSON.parse(response.body)
      end

      # HTTParty status code
      def code
        response.code
      end

      # HTTParty headers
      def headers
        response.headers.symbolize_keys
      end

      # Shipwire status
      def status
        json['status']
      end

      # Shipwire message
      def message
        json['message']
      end
    end
  end
end
