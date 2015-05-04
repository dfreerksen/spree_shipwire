module SpreeShipwire
  module Api
    include HTTParty

    format :json

    def perform(method, path, opt = {})
      options = request_options(opt)

      # binding.pry

      begin
        request = HTTParty.send(method, request_url(path), options)

        if request.body.include? 'Wrong email/password'
          raise BasicAuthenticationError
        elsif request.code == 200
          raise AuthenticationError
        else
          raise RequestError.new(recieved.message)
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
        body: options
      }
    end
  end
end
