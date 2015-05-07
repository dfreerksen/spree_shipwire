Spree::Order.class_eval do
#  state_machine.after_transition to: :complete,
#                                 do: :shipwire_order_processing
#
#  def shipwire_order_processing
#    binding.pry
#    # Spree::Shipwire::OrderWorker.perform_async(@order.number)
#  end

  def finalize_with_notify_shipwire!
    finalize_without_notify_shipwire!

    binding.pry
    # Spree::Shipwire::OrderWorker.perform_async(@order.number)
  end
  valias_method_chain :finalize!, :notify_shipwire!
end
