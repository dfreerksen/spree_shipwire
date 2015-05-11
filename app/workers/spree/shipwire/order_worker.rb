module Spree
  module Shipwire
    class OrderWorker
      include Sidekiq::Worker

      def perform(order_number)
        order = Spree::Order.find_by_number(order_number)

        SpreeShipwire::Orders.new(order).create
      end
    end
  end
end
