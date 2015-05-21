module SpreeShipwire
  module Response
    class Secrets < Base
      # Shipwire secret ID
      def id
        json['resource']['id']
      end

      # Shipwire secret token
      def token
        json['resource']['secret']
      end

      # Shipwire secret items
      def items
        json['resource']['items']
      end
    end
  end
end
