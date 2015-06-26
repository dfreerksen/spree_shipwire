module SpreeShipwire
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        %w(frontend backend).each do |loc|
          append_file("vendor/assets/javascripts/spree/#{loc}/all.js",
                      "//= require spree/#{loc}/spree_shipwire\n")
        end
      end

      def add_stylesheets
        %w(frontend backend).each do |loc|
          inject_into_file("vendor/assets/stylesheets/spree/#{loc}/all.css",
                           " *= require spree/#{loc}/spree_shipwire\n",
                           before: /\*\//,
                           verbose: true)
        end
      end
    end
  end
end
