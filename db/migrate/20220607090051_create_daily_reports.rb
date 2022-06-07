class CreateDailyReports < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_reports do |t|
      t.references :user_project, null: false, foreign_key: true
      t.datetime :date, null: false
      t.string :contents

      t.timestamps
    end
  end
end
