module SpreeShipwire
  class Engine < ::Rails::Engine
    require 'spree/core'
    isolate_namespace SpreeShipwire

    engine_name 'spree_shipwire'

    initializer 'spree_shipwire.initialize' do |app|
      ActiveSupport::Notifications.subscribe('order.complete') do |*args|
        events = ActiveSupport::Notifications::Event.new(*args)

        Spree::Shipwire::OrderWorker.perform_async(events.payload[:order])
      end

      ActiveSupport::Notifications.subscribe('order.cancel') do |*args|
        events = ActiveSupport::Notifications::Event.new(*args)

        Spree::Shipwire::CancelOrderWorker.perform_async(events.payload[:order])
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
