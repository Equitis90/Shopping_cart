class AddTotalToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :total, :boolean, null: false, :default => false
  end
end
