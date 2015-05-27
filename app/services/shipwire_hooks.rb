module ShipwireHooks
  attr_reader :webhooks

  TOPICS = ['order.created', 'order.updated', 'order.canceled',
            'tracking.created', 'tracking.updated', 'tracking.delivered']

  def load_webhooks
    @webhooks = SpreeShipwire::Webhooks.new.list

    combine
  end

  def secret_tokens(id = '', token = '')
    Spree::Shipwire::Config.shipwire_secret_id    = id
    Spree::Shipwire::Config.shipwire_secret_token = token
  end

  def webhook_url
    "https://#{Spree::Store.current.url}#{shipwire_webhooks_path}"
  end

  def secret_token_id
    Spree::Shipwire::Config.shipwire_secret_id
  end

  private

  def combine
    result = descriptions

    webhooks.items.each do |hook|
      id    = hook['resource']['id']
      topic = topic_symbol(hook['resource']['topic'])

      result[topic][:id] = id
    end

    result
  end

  def descriptions
    {
      order_created: {
        description: 'Notifies when a new order is created.',
      },
      order_updated: {
        description: 'Notifies whenever data on the order is updated.',
      },
      order_canceled: {
        description: 'Notifies when an order is canceled.',
      },
      tracking_created: {
        description: 'Notifies when a new tracking number is added on an
                      order.',
      },
      tracking_updated: {
        description: 'Notifies when the tracking resource is updated (e.g.
                      order has reached destination city).',
      },
      tracking_delivered: {
        description: 'Notifies when the tracking resource detects carton
                      delivery.',
      }
    }
  end

  def topic_symbol(topic)
    topic.
      gsub(/^v[0-9+]\./, ''). # Shipwire versions their topics. Cut that out
      gsub('.', '_').
      to_sym
  end
end
