class ChangeColumnToDate < ActiveRecord::Migration[6.0]
  def change
    change_column :daily_reports, :date, :date
  end
end
