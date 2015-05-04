module Spree
  module Shipwire
    class OrderWorker
      include Sidekiq::Worker

      def perform(order_id)
        order = Spree::Order.find(order_id)

        SpreeShipwire::Orders.new(order).create
      end
    end
  end
end
