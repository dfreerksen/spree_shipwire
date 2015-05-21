module Spree
  class ShipwireSetting < Preferences::Configuration
    preference :shipwire_secret_id, :string, default: ''
    preference :shipwire_secret_token, :string, default: ''
  end
end
