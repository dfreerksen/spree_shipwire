require 'spec_helper'

describe Spree::Admin::ShipwiresController, type: :controller do
  stub_authorization!

  context "enabling invalid topic" do
    it "fails with message" do
      spree_post(:enable, topic: "fake_topic")

      expect(response).to redirect_to spree.admin_shipwire_path
      expect(flash[:error]).to be_present
    end
  end
end
