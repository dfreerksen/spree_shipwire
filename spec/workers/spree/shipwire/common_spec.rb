require "spec_helper"

describe Spree::Shipwire::OrderWorker, type: :worker, vcr: true do
  let(:order) { create(:completed_order_with_totals) }

  describe 'with missing credentials' do
    before do
      SpreeShipwire.configuration.username = nil
      SpreeShipwire.configuration.password = nil
    end

    it 'raises an error' do
      worker = Spree::Shipwire::OrderWorker.new

      expect { worker.perform(order.number) }.to(
        raise_error(SpreeShipwire::AuthenticationError)
      )
    end
  end

  describe 'with incorrect credentials' do
    before do
      SpreeShipwire.configuration.username = 'fake@email.com'
      SpreeShipwire.configuration.password = 'kick-ass-password'
    end

    it 'raises an error' do
      VCR.use_cassette("incorrect_credentials") do
        worker = Spree::Shipwire::OrderWorker.new

        expect { worker.perform(order.number) }.to(
          raise_error(SpreeShipwire::BasicAuthenticationError)
        )
      end
    end
  end

  describe 'with API timeout' do
    before { SpreeShipwire.configuration.timeout = 0.0001 }

    it 'raises an error' do
      VCR.use_cassette("request_timeout") do
        worker = Spree::Shipwire::OrderWorker.new

        expect { worker.perform(order.number) }.to(
          raise_error(SpreeShipwire::RequestTimeout)
        )
      end
    end
  end
end
