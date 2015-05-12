module SpreeShipwire
  module Components
    class Declaration
      attr_accessor :order

      def initialize(order)
        @order = order
      end

      def to_hash
        {
          shippingValue:           order.shipment_total,
          additionalValue:         order.additional_tax_total,
          shippingValueCurrency:   order.currency,
          insuranceValueCurrency:  order.currency,
          additionalValueCurrency: order.currency
        }
      end
    end
  end
end
