module SpreeShipwire
  module Response
    class Orders < Base
      # Shipwire page offset
      def page_offset
        json['resource']['offset']
      end

      # Shipwire total pages
      def total_pages
        json['resource']['total']
      end

      # Shipwire previous page
      def previous_page
        json['resource']['previous']
      end

      # Shipwire next page
      def next_page
        json['resource']['next']
      end

      # Shipwire items
      def items
        json['resource']['items']
      end
    end
  end
end
