module SpreeShipwire
  module Response
    class Webhooks < Base
      # Shipwire webhook ID
      def id
        json['resource']['id']
      end

      # Shipwire webhook topic
      def topic
        json['resource']['topic']
      end

      # Shipwire webhook URL
      def url
        json['resource']['url']
      end

      # Shipwire items
      def items
        json['resource']['items']
      end

      # Shipwire errors
      def errors
        json['errors']
      end
    end
  end
end
