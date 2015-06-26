module SpreeShipwire
  class Engine < ::Rails::Engine
    require "spree/core"
    isolate_namespace SpreeShipwire

    engine_name "spree_shipwire"

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_shipwire.initialize" do
      ActiveSupport::Notifications.subscribe("order.complete") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)

        Spree::Shipwire::OrderWorker.perform_async event.payload[:order]
      end
    end

    def self.activate
      Dir.glob("#{config.root}/app/**/*_decorator*.rb") do |klass|
        Rails.configuration.cache_classes ? require(klass) : load(klass)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
