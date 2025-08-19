class CreateOrderLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_line_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :price_cents, null: false

      t.timestamps
    end
  end
end
