module Spree
  module Admin
    class ShipwiresController < BaseController
      before_action :validate_topic, only: [:enable]

      helper_method :secret_token_id

      TOPICS = ['order.created', 'order.updated', 'order.canceled',
                'tracking.created', 'tracking.updated', 'tracking.delivered']

      def show
        hooks = SpreeShipwire::Webhooks.new.list

        unless hooks.code == 200
          flash.now[:notice] = "Shit. It didn't get loaded."
        end

        @webhooks = {
          'order_created' => {
            description: 'Notifies when a new order is created.',
            id:          nil
          },
          'order_updated' => {
            description: 'Notifies whenever data on the order is updated.',
            id:          nil
          },
          'order_canceled' => {
            description: 'Notifies when an order is canceled.',
            id:          nil
          },
          'tracking_created' => {
            description: 'Notifies when a new tracking number is added on an
                          order.',
            id:          nil
          },
          'tracking_updated' => {
            description: 'Notifies when the tracking resource is updated (e.g.
                          order has reached destination city).',
            id:          nil
          },
          'tracking_delivered' => {
            description: 'Notifies when the tracking resource detects carton
                          delivery.',
            id:          nil
          }
        }

        hooks.items.each do |hook|
          id    = hook['resource']['id']
          topic = hook['resource']['topic'].gsub(/v[0-9+]\./, '')
                                           .gsub('.', '_')

          @webhooks[topic][:id] = id
        end
      end

      def enable
        subscription = SpreeShipwire::Webhooks.new.create(@topic, webhook_url)

        if subscription.status == 200
          message = { success: Spree.t('shipwire.admin.flash.enable_success') }
        else
          reason = subscription.errors.to_sentence

          message = {
            error: Spree.t('shipwire.admin.flash.enable_error', reason: reason)
          }
        end

        redirect_to admin_shipwire_path, flash: message
      end

      def disable
        SpreeShipwire::Webhooks.new.remove(params[:topic])

        redirect_to admin_shipwire_path, flash: {
          success: Spree.t('shipwire.admin.flash.disable_success')
        }
      end

      def secret_create
        secret = SpreeShipwire::Secrets.new.create

        Spree::Shipwire::Config.shipwire_secret_id    = secret.id
        Spree::Shipwire::Config.shipwire_secret_token = secret.token

        redirect_to admin_shipwire_path, flash: {
          success: Spree.t('shipwire.admin.flash.token_create_success')
        }
      end

      def secret_remove
        id = Spree::Shipwire::Config.shipwire_secret_id

        SpreeShipwire::Secrets.new.remove(id)

        Spree::Shipwire::Config.shipwire_secret_id    = ""
        Spree::Shipwire::Config.shipwire_secret_token = ""

        redirect_to admin_shipwire_path, flash: {
          success: Spree.t('shipwire.admin.flash.token_remove_success')
        }
      end

      protected

      def secret_token_id
        Spree::Shipwire::Config.shipwire_secret_id
      end

      private

      def validate_topic
        @topic = params[:topic].gsub('_', '.')

        binding.pry
        unless TOPICS.include?(@topic)
          redirect_to admin_shipwire_path, flash: {
            error: Spree.t('shipwire.admin.flash.unkown_topic')
          }
        end
      end

      def webhook_url
        "https://#{Spree::Store.current.url}#{shipwire_webhooks_path}"
      end
    end
  end
end
