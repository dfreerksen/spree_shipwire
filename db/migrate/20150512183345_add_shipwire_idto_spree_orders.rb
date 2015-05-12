class AddShipwireIdtoSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :shipwire_id, :string
  end
end
