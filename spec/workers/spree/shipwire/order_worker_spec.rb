require "spec_helper"

describe Spree::Shipwire::OrderWorker, type: :worker, vcr: true do
  let(:order) { create(:completed_order_with_totals) }

  describe 'with incomplete request' do
    it 'raises an error' do
      VCR.use_cassette("order_incomplete") do
        bad_order = create(:order)

        worker = Spree::Shipwire::OrderWorker.new

        expect { worker.perform(bad_order.number) }.to raise_error
      end
    end
  end

  describe 'with valid request' do
    it 'sends order' do
      VCR.use_cassette("order_create") do
        worker = Spree::Shipwire::OrderWorker.new

        request = worker.perform(order.number)

        expect(request.code).to eq 200
        expect(request.headers).to_not be_empty

        expect(request.status).to eq 200
        expect(request.message).to eq "Successful"
        expect(request.page_offset).to eq 0
        expect(request.total_pages).to eq 1
        expect(request.previous_page).to eq nil
        expect(request.next_page).to eq nil
        expect(request.items.count).to eq 1
      end
    end
  end
end
