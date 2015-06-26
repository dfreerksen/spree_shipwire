module Spree
  module Shipwire
    class OrderWorker
      include Sidekiq::Worker

      sidekiq_options retry: false

      attr_reader :order

      def perform(order_number)
        @order = Spree::Order.find_by_number(order_number)

        ::Shipwire::Orders.new.create(payload)
      end

      protected

      def payload
        {
          orderNo:           @order.number,
          externalId:        @order.number,
          items:             line_items,
          options:           order_options,
          shipTo:            ship_to,
          commercialInvoice: commercial_invoice
        }
      end

      def line_items
        @order.line_items.each_with_object([]) do |item, hsh|
          hsh << {
            sku:                           item.sku,
            quantity:                      item.quantity,
            commercialInvoiceValue:        item.cost_price.to_s,
            commercialInvoiceValueCurrenc: item.currency
          }
        end
      end

      def order_options
        {
          currency: @order.currency,
          canSplit: 1
        }
      end

      def ship_to
        return {} if @order.shipping_address.nil?

        {
          email:      @order.email,
          name:       @order.shipping_address.full_name,
          company:    @order.shipping_address.company,
          address1:   @order.shipping_address.address1,
          address2:   @order.shipping_address.address2,
          city:       @order.shipping_address.city,
          state:      @order.shipping_address.state.abbr,
          postalCode: @order.shipping_address.zipcode,
          country:    @order.shipping_address.country.iso,
          phone:      @order.shipping_address.phone
        }
      end

      def commercial_invoice
        {
          shippingValue:           @order.shipment_total.to_s,
          shippingValueCurrency:   @order.currency,
          insuranceValueCurrency:  @order.currency,
          additionalValueCurrency: @order.currency
        }
      end
    end
  end
end
