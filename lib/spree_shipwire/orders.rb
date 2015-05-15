module SpreeShipwire
  class Orders
    include Api

    attr_accessor :order

    def initialize(order)
      @order = order
    end

    def create
      options = {
        orderNo:           order.number,
        externalId:        order.id,
        options:           order_options,
        items:             order_items,
        shipTo:            shipping_address,
        commercialInvoice: customs_declaration
      }

      options[:externalId] = order.number unless Rails.env.production?

      request(:post, '/api/v3/orders', options)
    end

    def cancel
      request(:post, "/api/v3/orders/#{order.shipwire_id}/cancel")
    end

    private

    def request(method, path, options = {})
      response = perform(method, path, options)

      SpreeShipwire::Response::Orders.new(response)
    end

    def order_options
      Components::Options.new(order).to_hash
    end

    def order_items
      Components::Items.new(order).to_hash
    end

    def shipping_address
      Components::Address.new(order).to_hash
    end

    def customs_declaration
      Components::Declaration.new(order).to_hash
    end
  end
end
