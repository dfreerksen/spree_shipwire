module SpreeShipwire
  class Webhooks
    include Api

    def list
      request(:get, '/api/v3/webhooks')
    end

    def create(topic, url)
      options = {
        topic: topic,
        url:   url,
      }

      request(:post, '/api/v3/webhooks', options)
    end

    def remove(id)
      request(:delete, "/api/v3/webhooks/#{id}")
    end

    private

    def request(method, path, options = {})
      response = perform(method, path, options)

      SpreeShipwire::Response::Webhooks.new(response)
    end
  end
end
