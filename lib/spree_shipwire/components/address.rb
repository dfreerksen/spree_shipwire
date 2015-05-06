module SpreeShipwire
  module Components
    class Address
      attr_accessor :address, :email

      def initialize(order)
        @address = order.shipping_address
        @email   = order.email
      end

      def to_hash
        {
          email:      email,
          name:       address.full_name,
          company:    address.company,
          address1:   address.address1,
          address2:   address.address2,
          city:       address.city,
          state:      address.state.abbr,
          postalCode: address.zipcode,
          country:    address.country.iso,
          phone:      address.phone,
          isPoBox:    po_box?
        }
      end

      def po_box?
        re = /(?i)^\s*((P(OST)?.?\s*(O(FF(ICE)?)?)?.?\s+(B(IN|OX))?)|B(IN|OX))/i

        !re.match(address.address1).nil?
      end
    end
  end
end
