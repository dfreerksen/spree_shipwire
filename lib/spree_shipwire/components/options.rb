module SpreeShipwire
  module Components
    class Options
      attr_accessor :order

      def initialize(order)
        @order = order
      end

      def to_hash
        {
          currency:  order.currency,
          testOrder: !Rails.env.production?
        }
      end
    end
  end
end
