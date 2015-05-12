module Spree
  module Shipwire
    class OrderWorker
      include Sidekiq::Worker

      def perform(order_number)
        order = Spree::Order.find_by_number(order_number)

        result = SpreeShipwire::Orders.new(order).create

        # This is temporary until webhooks are in place
        if result.code == 200
          order.update(shipwire_id: result.items.first['resource']['id'])
        end

        result
      end
    end
  end
end
