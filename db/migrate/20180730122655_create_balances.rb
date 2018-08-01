class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.string :address
      t.string :ticker
      t.string :balance

      t.timestamps
    end
  end
end
