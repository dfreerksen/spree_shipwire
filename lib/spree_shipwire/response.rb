require 'json'

module SpreeShipwire
  class Response
    attr_reader :response, :json

    def initialize(response)
      @response = response
      @json = OpenStruct.new(JSON.parse(response.body))
    end

    # HTTParty status code
    def code
      response.code
    end

    # HTTParty headers
    def headers
      response.headers.symbolize_keys!
    end

    # Shipwire status
    def status
      json.status
    end

    # Shipwire message
    def message
      json.message
    end

    # Shipwire page offset
    def page_offset
      json.resource.offset
    end

    # Shipwire total pages
    def total_pages
      json.resource.total
    end

    # Shipwire previous page
    def previous_page
      json.resource.previous
    end

    # Shipwire next page
    def next_page
      json.resource.next
    end

    # Shipwire items
    def items
      json.resource.items
    end
  end
end
