class CreateCartItems < ActiveRecord::Migration[7.2]
  def change
    create_table :cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :price_cents, null: false

      t.timestamps
    end
    
    add_index :cart_items, [:cart_id, :product_id], unique: true, name: 'index_cart_items_on_cart_and_product'
  end
end
