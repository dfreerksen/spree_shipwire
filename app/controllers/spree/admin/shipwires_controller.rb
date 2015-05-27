module Spree
  module Admin
    class ShipwiresController < BaseController
      include ShipwireHooks

      before_action :validate_topic, only: [:enable]

      helper_method :secret_token_id

      def show
        begin
          @webhooks = load_webhooks
        rescue
          @webhooks = []

          flash.now[:notice] = Spree.t('shipwire.admin.flash.hook_list_error')
        end
      end

      def enable
        subscription = SpreeShipwire::Webhooks.new.create(@topic, webhook_url)

        if subscription.status == 200
          redirect_with_flash(admin_shipwire_path,
                              :success,
                              Spree.t('shipwire.admin.flash.enable_success'))
        else
          reason = subscription.errors.to_sentence

          message = Spree.t('shipwire.admin.flash.enable_error', reason: reason)

          redirect_with_flash(admin_shipwire_path, :error, message)
        end
      end

      def disable
        SpreeShipwire::Webhooks.new.remove(params[:topic])

        redirect_with_flash(admin_shipwire_path,
                            :success,
                            Spree.t('shipwire.admin.flash.disable_success'))
      end

      def secret_create
        begin
          secret = SpreeShipwire::Secrets.new.create

          secret_tokens(secret.id, secret.token)

          message = Spree.t('shipwire.admin.flash.token_create_success')

          redirect_with_flash(admin_shipwire_path, :success, message)
        rescue
          message = Spree.t('shipwire.admin.flash.token_create_error')

          redirect_with_flash(admin_shipwire_path, :error, message)
        end
      end

      def secret_remove
        id = Spree::Shipwire::Config.shipwire_secret_id

        SpreeShipwire::Secrets.new.remove(id)

        secret_tokens

        message = Spree.t('shipwire.admin.flash.token_remove_success')

        redirect_with_flash(admin_shipwire_path, :success, message)
      end

      private

      def redirect_with_flash(location, flash_type, message)
        redirect_to location, flash: { "#{flash_type}" => message }
      end

      def validate_topic
        @topic = params[:topic].gsub('_', '.')

        unless TOPICS.include?(@topic)
          redirect_with_flash(admin_shipwire_path,
                              :error,
                              Spree.t('shipwire.admin.flash.unkown_topic'))
        end
      end
    end
  end
end
