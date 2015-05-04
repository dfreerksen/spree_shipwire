require "spree_core"
require "spree_shipwire/engine"

require "httparty"

require "spree_shipwire/configuration"
require "spree_shipwire/api"
require "spree_shipwire/response"
require "spree_shipwire/errors"
require "spree_shipwire/orders"
require "spree_shipwire/components/address"
require "spree_shipwire/components/items"
require "spree_shipwire/components/options"

module SpreeShipwire
  class << self
    attr_writer :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end