require "spec_helper"

describe Spree::Shipwire::CancelOrderWorker, type: :worker, vcr: true do
  let!(:order) { create(:completed_order_with_totals) }

  describe 'when order does not exist' do
    before do
      order.update(shipwire_id: 'fake-shipwire-order-id')
      order.reload
    end

    it 'returns an error' do
      VCR.use_cassette("cancel_order_not_exist") do
        worker = Spree::Shipwire::CancelOrderWorker.new

        request = worker.perform(order.shipwire_id)

        expect(request.code).to eq 404

        expect(request.status).to eq 404
        expect(request.message).to eq "Order not found"
      end
    end
  end

  describe 'with valid request' do
    before do
      VCR.use_cassette("create_order_to_cancel") do
        worker = Spree::Shipwire::OrderWorker.new

        request = worker.perform(order.number)

        order.update(shipwire_id: request.items.first['resource']['id'])
        order.reload
      end
    end

    it 'cancels order' do
      VCR.use_cassette("cancel_order") do
        worker = Spree::Shipwire::CancelOrderWorker.new

        request = worker.perform(order.shipwire_id)

        expect(request.code).to eq 200

        expect(request.status).to eq 200
        expect(request.message).to eq "Order cancelled"
      end
    end
  end
end
