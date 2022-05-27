class CreateUserCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :user_companies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
    end
  end
end
