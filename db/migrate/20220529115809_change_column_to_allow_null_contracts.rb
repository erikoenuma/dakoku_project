class ChangeColumnToAllowNullContracts < ActiveRecord::Migration[6.0]
  def change
    change_column :contracts, :wage, :integer, null: true
    change_column :contracts, :wage_per, :string, null: true
    change_column :contracts, :hours_per_month, :integer, null: true
  end

  def down
    change_column :contracts, :wage, :integer, null: false
    change_column :contracts, :wage_per, :string, null: false
    change_column :contracts, :hours_per_month, :integer, null: false
  end
end
