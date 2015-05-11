require 'spec_helper'

describe "Admin", type: :feature do
  stub_authorization!

  let(:user) { double(id: 123, has_spree_role?: true, spree_api_key: 'fake') }

  before do
    allow_any_instance_of(Spree::Admin::BaseController).to(
      receive(:try_spree_current_user).and_return(user)
    )
  end

  let(:order) do
    order = create(:order)

    order.update_columns({
      state: :complete,
      completed_at: Time.now
    })
    order
  end

  context "canceling an order", js: true do
    it "notifies Shipwire" do
      visit spree.edit_admin_order_path(order.number)

      expect(Spree::Shipwire::CancelOrderWorker.jobs.count).to eq 0

      accept_alert do
        click_button 'cancel'
      end

      expect(Spree::Shipwire::CancelOrderWorker.jobs.count).to eq 1
    end
  end
end
