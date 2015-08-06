class AddActiveToProduct < ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, :null => false, :default => true
    add_column :products, :type_id, :integer
  end
end
