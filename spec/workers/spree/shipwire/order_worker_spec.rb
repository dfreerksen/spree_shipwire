require "spec_helper"

describe Spree::Shipwire::OrderWorker, type: :worker do
  before(:each) do
    SpreeShipwire.configure do |c|
      c.username = "david.freerksen@groundctrl.com"
      c.password = "18530b0bb04349009c7b2ca1d05c70f3"
      c.timeout = 10
    end
  end

  let(:order) { create(:completed_order_with_totals) }

  describe 'with incomplete request' do
    it 'raises an error' do
      bad_order = create(:order)

      worker = Spree::Shipwire::OrderWorker.new

      expect { worker.perform(bad_order) }.to raise_error
    end
  end

  describe 'with missing credentials' do
    before do
      SpreeShipwire.configuration.username = nil
      SpreeShipwire.configuration.password = nil
    end

    it 'raises an error' do
      worker = Spree::Shipwire::OrderWorker.new

      expect { worker.perform(order) }.to(
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
      worker = Spree::Shipwire::OrderWorker.new

      expect { worker.perform(order) }.to(
        raise_error(SpreeShipwire::BasicAuthenticationError)
      )
    end
  end

  describe 'with API timeout' do
    before { SpreeShipwire.configuration.timeout = 0.0001 }

    it 'raises an error' do
      worker = Spree::Shipwire::OrderWorker.new

      expect { worker.perform(order) }.to(
        raise_error(SpreeShipwire::RequestTimeout)
      )
    end
  end

  describe 'with valid request' do
    it 'sends order' do
      worker = Spree::Shipwire::OrderWorker.new

      request = worker.perform(order)

      binding.pry
      expect(request.code).to eq 200
      expect(request.headers).to_not be_empty

      expect(request.status).to eq "Successful"
      expect(request.page_offset).to eq 0
      expect(request.total_pages).to eq 1
      expect(request.previous_page).to eq nil
      expect(request.next_page).to eq nil
      expect(request.items).to eq {}
    end
  end
end
