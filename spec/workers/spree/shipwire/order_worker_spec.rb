require "spec_helper"

describe Spree::Shipwire::OrderWorker, type: :worker, vcr: true do
  let(:order) { create(:completed_order_with_totals) }

  describe "with incomplete request" do
    it "raises an error" do
      VCR.use_cassette("order_incomplete") do
        bad_order = create(:order)

        worker = Spree::Shipwire::OrderWorker.new

        request = worker.perform(bad_order.number)

        expect(request.errors).to include "Order has no shipping address"
        expect(request.errors).to include "No items in order"
      end
    end
  end

  describe "with valid request" do
    it "sends order" do
      VCR.use_cassette("order_create") do
        worker = Spree::Shipwire::OrderWorker.new

        request = worker.perform(order.number)


        expect(request.ok?).to be_truthy
        expect(request.response.resource.items.count).to eq 1
      end
    end
  end
end
