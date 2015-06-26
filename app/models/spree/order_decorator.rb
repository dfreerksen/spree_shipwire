Spree::Order.class_eval do
  state_machine.after_transition to: :complete,
                                 do: :shipwire_order_processing

  def shipwire_order_processing
    ActiveSupport::Notifications.instrument("order.complete", order: number)
  end
end
