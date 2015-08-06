class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total, :null => false, :default => 0
      t.decimal :discount, :null => false, :default => 0

      t.timestamps null: false
    end
  end
end
