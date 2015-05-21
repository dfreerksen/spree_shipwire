require 'spec_helper'

describe "Webhooks", type: :feature, vcr: true do
  stub_authorization!

  before { create(:store, url: 'demo.spreecommerce.com') }

  context "enabling a webhook" do
    context "with valid callback URL" do
      before { webhook_cleaner("before") }

      after { webhook_cleaner("after") }

      it "is successful" do
        VCR.use_cassette("enabled_webhooks_success") do
          visit spree.admin_shipwire_path

          within(:css, "table.table tbody tr:nth-child(1)") do
            click_link "Enable"
          end

          expect(current_path).to eq spree.admin_shipwire_path
          expect(page).to have_content(
            Spree.t('shipwire.admin.flash.enable_success')
          )
        end
      end

      xit "cannot load current webhooks" do
        VCR.use_cassette("enabled_webhooks_error") do
          SpreeShipwire.configuration.timeout = 0.0001

          visit spree.admin_shipwire_path

          binding.pry
          within(:css, "table.table tbody tr:nth-child(1)") do
            click_link "Enable"
          end

          expect(current_path).to eq spree.admin_shipwire_path
          expect(page).to have_content(
            Spree.t('shipwire.admin.flash.enable_success')
          )
        end
      end
    end

    context "with invalid callback URL" do
      before { Spree::Store.default.update(url: 'www.example.com') }

      it "is not successful" do
        VCR.use_cassette("enabled_webhooks_invalid_callback_url") do
          visit spree.admin_shipwire_path

          within(:css, "table.table tbody tr:nth-child(1)") do
            click_link "Enable"
          end

          expect(current_path).to eq spree.admin_shipwire_path
          expect(page).to have_content 'Could not enable webhook.'
        end
      end
    end
  end

  context "disabling a webhook" do
    before do
      VCR.use_cassette("disabled_webhooks_before") do
        visit spree.admin_shipwire_path

        within(:css, "table.table tbody tr:nth-child(1)") do
          click_link "Enable"
        end
      end
    end

    it "is successful" do
      VCR.use_cassette("disabled_webhooks") do
        visit spree.admin_shipwire_path

        within(:css, "table.table tbody tr:nth-child(1)") do
          click_link "Disable"
        end

        expect(current_path).to eq spree.admin_shipwire_path
        expect(page).to have_content(
          Spree.t('shipwire.admin.flash.disable_success')
        )
      end
    end
  end

  def webhook_cleaner(when_action)
    VCR.use_cassette("enabled_webhooks_remove_all_#{when_action}") do
      webhooks = SpreeShipwire::Webhooks.new.list

      webhooks.items.each do |webhook|
        SpreeShipwire::Webhooks.new.remove webhook['resource']['id']
      end
    end
  end
end
