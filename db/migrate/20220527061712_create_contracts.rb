class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.references :user_project, null: false, foreign_key: true
      t.integer :wage, null: false
      t.string :wage_per, null: false
      t.integer :hours_per_month, null: false
      t.date :start_at, null: false
      t.date :end_at
      t.boolean :daily_reports_required, null: false, default: false
      t.string :role, null: false
      t.boolean :under_contract, null: false, default: true

      t.timestamps
    end
  end
end
