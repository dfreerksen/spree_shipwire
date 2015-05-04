require 'json'

module SpreeShipwire
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    # HTTParty status code
    def code
      response.code
    end

    # HTTParty headers
    def headers
      response.headers.symbolize_keys
    end

    # Shipwire status
    def status
      response.body.status
    end

    # Shipwire page offset
    def page_offset
      response.body.resource.offset
    end

    # Shipwire total pages
    def total_pages
      response.body.resource.total
    end

    # Shipwire previous page
    def previous_page
      response.body.resource.previous
    end

    # Shipwire next page
    def next_page
      response.body.resource.next
    end

    # Shipwire items
    def items
      response.body.resource.items
    end
  end
end
