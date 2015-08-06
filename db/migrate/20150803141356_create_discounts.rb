class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :product_id
      t.integer :product_type_id
      t.integer :quantity, :null => false, :default => 1
      t.boolean :percent, :null => false, :default => false
      t.decimal :value, :null => false, :default => 0
      t.boolean :active, :null => false, :default => true

      t.timestamps null: false
    end
  end
end
