module Spree
  module Shipwire
    class CancelOrderWorker
      include Sidekiq::Worker

      def perform(order_number)
        order = Spree::Order.find_by_number(order_number)

        SpreeShipwire::Orders.new(order).cancel
      end
    end
  end
end
