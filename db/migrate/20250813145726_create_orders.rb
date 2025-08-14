class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.integer :total_cents, null: false, default: 0
      t.integer :delivery_fee_cents, default: 0, null: false

      t.timestamps
    end
  end
end
