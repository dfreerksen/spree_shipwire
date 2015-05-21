require 'spec_helper'

describe "Webhook secret tokens", type: :feature, vcr: true do
  stub_authorization!

  context "creating secret token" do
    before { secret_cleaner("before") }

    after { secret_cleaner("after") }

    it "is successful" do
      VCR.use_cassette("secret_token_create") do
        visit spree.admin_shipwire_path

        click_link Spree.t('shipwire.admin.secret.unavailable.link')

        expect(current_path).to eq spree.admin_shipwire_path
        expect(page).to have_content(
          Spree.t('shipwire.admin.flash.token_create_success')
        )
      end

    end
  end

  context "removing secret token" do
    before do
      # Fake it. Even if the ID doesn't exist, the purpose was the remove it. If
      # it never existed, the end result is the same. It's not there.
      Spree::Shipwire::Config.shipwire_secret_id = "123"
    end

    it "is successful" do
      VCR.use_cassette("secret_token_remove") do
        visit spree.admin_shipwire_path

        click_link Spree.t('shipwire.admin.secret.available.link')

        expect(current_path).to eq spree.admin_shipwire_path
        expect(page).to have_content(
          Spree.t('shipwire.admin.flash.token_remove_success')
        )
      end
    end
  end

  def secret_cleaner(when_action)
    VCR.use_cassette("secret_token_remove_all_#{when_action}") do
      secrets = SpreeShipwire::Secrets.new.list

      secrets.items.each do |secret|
        SpreeShipwire::Secrets.new.remove secret['resource']['id']
      end

      Spree::Shipwire::Config.shipwire_secret_id = ""
      Spree::Shipwire::Config.shipwire_secret_token = ""
    end
  end
end
