require "spree_core"
require "httparty"

require "active_support/notifications"

require "spree_shipwire/engine"
require "spree_shipwire/errors"
require "spree_shipwire/configuration"
require "spree_shipwire/api"
require "spree_shipwire/errors"

require "spree_shipwire/orders"
require "spree_shipwire/secrets"
require "spree_shipwire/webhooks"

require "spree_shipwire/response/base"
require "spree_shipwire/response/orders"
require "spree_shipwire/response/secrets"
require "spree_shipwire/response/webhooks"

require "spree_shipwire/components/address"
require "spree_shipwire/components/declaration"
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
