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
          phone:      address.phone
        }
      end
    end
  end
end
