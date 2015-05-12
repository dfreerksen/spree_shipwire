Spree::Order.class_eval do
  state_machine.after_transition to: :complete,
                                 do: :shipwire_order_processing

  def shipwire_order_processing
    ActiveSupport::Notifications.instrument('order.complete', order: number)
  end

  def canceled_by_with_notify_shipwire(user)
    canceled_by_without_notify_shipwire(user)

    ActiveSupport::Notifications.instrument('order.cancel', order: number)
  end
  alias_method_chain :canceled_by, :notify_shipwire
end
