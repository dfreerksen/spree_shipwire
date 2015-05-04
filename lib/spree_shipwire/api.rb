module SpreeShipwire
  module Api
    include HTTParty

    format :json

    def perform(method, path, opt = {})
      options = request_options(opt)

      begin
        request = HTTParty.send(method, request_url(path), options)

        response = SpreeShipwire::Response.new(request)

        binding.pry

        if response.message.include? 'Please include a valid Authorization header'
          raise BasicAuthenticationError
        else
          response
        end
      rescue Net::OpenTimeout => e
        raise RequestTimeout.new(e.message)
      end
    end

    private

    def request_url(path)
      "#{SpreeShipwire.configuration.endpoint}#{path}"
    end

    def request_options(options = {})
      config = SpreeShipwire.configuration

      if config.username.nil? || config.password.nil?
        raise AuthenticationError
      end

      {
        timeout: config.timeout,
        headers: {
          'Content-Type' => 'application/json'
        },
        basic_auth: {
          username: config.username,
          password: config.password
        },
        body: options.to_json
      }
    end
  end
end
