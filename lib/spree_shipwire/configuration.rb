module SpreeShipwire
  class Configuration
    attr_accessor :username,
                  :password,
                  :timeout

    attr_reader :endpoint,
                :server

    def initialize
      @username = nil
      @password = nil
      @timeout  = 10
      @endpoint = endpoint
      @server   = server
    end

    def endpoint
      beta = Rails.env.production? ? '' : '.beta'

      "https://api#{beta}.shipwire.com"
    end

    def server
      Rails.env.production? ? 'Production' : 'Test'
    end
  end
end
