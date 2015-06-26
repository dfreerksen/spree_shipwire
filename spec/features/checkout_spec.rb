require "spec_helper"

describe "Checkout", type: :feature do
  let!(:country) { create(:country, states_required: true) }
  let!(:state) { create(:state, country: country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:product) { create(:product) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }
  let!(:store) { create(:store) }

  context "stepping through checkout", js: true do
    it "sends order to Shipwire" do
      add_product_to_cart

      # Cart view
      click_on "Checkout"

      # Checkout as guest
      expect(Spree::Shipwire::OrderWorker.jobs.count).to eq 0
      fill_in "order_email", with: "test@example.com"
      click_on "Continue"

      # Addresses
      expect(Spree::Shipwire::OrderWorker.jobs.count).to eq 0
      fill_in_address
      click_on "Save and Continue"

      # Delievery
      expect(Spree::Shipwire::OrderWorker.jobs.count).to eq 0
      click_on "Save and Continue"

      # Payment
      expect(Spree::Shipwire::OrderWorker.jobs.count).to eq 0
      click_on "Save and Continue"

      # Complete
      expect(Spree::Shipwire::OrderWorker.jobs.count).to eq 1
    end
  end

  def fill_in_address
    address = "order_bill_address_attributes"
    fill_in "#{address}_firstname", with: "John"
    fill_in "#{address}_lastname", with: "Doe"
    fill_in "#{address}_address1", with: "1234 Street Rd."
    fill_in "#{address}_city", with: "Somewhere"
    select "United States of America", from: "#{address}_country_id"
    select "Alabama", from: "#{address}_state_id"
    fill_in "#{address}_zipcode", with: "12345"
    fill_in "#{address}_phone", with: "(555) 555-5555"
  end

  def add_product_to_cart
    visit spree.root_path
    click_link product.name
    click_button "add-to-cart-button"
  end
end
