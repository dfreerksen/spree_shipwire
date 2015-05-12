module Spree
  module Shipwire
    class CancelOrderWorker
      include Sidekiq::Worker

      def perform(shipwire_order_id)
        order = Spree::Order.find_by_shipwire_id(shipwire_order_id)

        SpreeShipwire::Orders.new(order).cancel
      end
    end
  end
end
