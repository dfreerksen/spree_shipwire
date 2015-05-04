module SpreeShipwire
  class Error < StandardError; end

  class RequestError < Error; end

  class RequestTimeout < RequestError; end

  class BasicAuthenticationError < Error; end

  class AuthenticationError < Error; end
end
