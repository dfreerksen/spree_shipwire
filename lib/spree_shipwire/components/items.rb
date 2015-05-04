module SpreeShipwire
  module Components
    class Items
      attr_accessor :items

      def initialize(order)
        @items = order.line_items
      end

      def to_hash
        [] << items.each_with_object({}) do |item, hsh|
          hsh[:sku]      = item[:sku]
          hsh[:quantity] = item[:quantity]
        end
      end
    end
  end
end
