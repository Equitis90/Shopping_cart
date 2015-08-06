class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, :null => false
      t.decimal :price, :null => false, :default => 0

      t.timestamps null: false
    end
  end
end
