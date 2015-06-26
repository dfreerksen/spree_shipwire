require "spec_helper"

describe Spree::Shipwire::OrderWorker, type: :worker, vcr: true do
  let(:order) { create(:completed_order_with_totals) }

  describe "with missing credentials" do
    before do
      Shipwire.configuration.username = nil
      Shipwire.configuration.password = nil
    end

    it "raises an error" do
      VCR.use_cassette("missing_credentials") do
        worker = Spree::Shipwire::OrderWorker.new

        expect(worker.perform(order.number).errors).to include(
          "Please include a valid Authorization header (Basic)"
        )
      end
    end
  end

  describe "with incorrect credentials" do
    before do
      Shipwire.configuration.username = "fake@email.com"
      Shipwire.configuration.password = "kick-ass-password"
    end

    it "raises an error" do
      VCR.use_cassette("incorrect_credentials") do
        worker = Spree::Shipwire::OrderWorker.new

        expect(worker.perform(order.number).errors).to include(
          "Please include a valid Authorization header (Basic)"
        )
      end
    end
  end

  describe "with API timeout" do
    before { Shipwire.configuration.timeout = 0.0001 }

    it "raises an error" do
      worker = Spree::Shipwire::OrderWorker.new

      expect(worker.perform(order.number).errors).to include(
        "Shipwire connection timeout"
      )
    end
  end
end
