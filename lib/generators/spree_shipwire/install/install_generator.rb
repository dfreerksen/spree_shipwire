module SpreeShipwire
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        copy_file('config/initializers/spree_shipwire.rb',
                  'config/initializers/spree_shipwire.rb')
      end

      def add_javascripts
        append_file('vendor/assets/javascripts/spree/frontend/all.js',
                    "//= require spree/frontend/spree_shipwire\n")
        append_file('vendor/assets/javascripts/spree/backend/all.js',
                    "//= require spree/backend/spree_shipwire\n")
      end

      def add_stylesheets
        inject_into_file('vendor/assets/stylesheets/spree/frontend/all.css',
                         " *= require spree/frontend/spree_shipwire\n",
                         before: /\*\//,
                         verbose: true)
        inject_into_file('vendor/assets/stylesheets/spree/backend/all.css',
                         " *= require spree/backend/spree_shipwire\n",
                         before: /\*\//,
                         verbose: true)
      end
    end
  end
end
