module SpreeShipwire
  class Secrets
    include Api

    def list
      request(:get, '/api/v3/secret')
    end

    def create
      request(:post, '/api/v3/secret')
    end

    def remove(id)
      request(:delete, "/api/v3/secret/#{id}")
    end

    private

    def request(method, path, options = {})
      response = perform(method, path, options)

      SpreeShipwire::Response::Secrets.new(response)
    end
  end
end
