module SpreeShipwire
  class Orders
    include Api

    attr_accessor :order

    def initialize(order)
      @order = order
    end

    def create
      options = {
        orderNo:    order.number,
        externalId: order.id,
        options:    order_options,
        items:      order_items,
        shipTo:     shipping_address
      }

      perform(:post, '/api/v3/orders', options)
    end

    private

    def order_options
      Components::Options.new(order).to_hash
    end

    def order_items
      Components::Items.new(order).to_hash
    end

    def shipping_address
      Components::Address.new(order).to_hash
    end
  end
end
