Spree::CheckoutController.class_eval do
  after_action :shipwire_order_processing

  protected

  def shipwire_order_processing
    if (params[:state] == 'complete')
      Spree::Shipwire::OrderWorker.perform_async(@order.id)
    end
  end
end
