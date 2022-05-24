class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :zipcode
      t.string :phone_number
      t.string :email
      t.string :url

      t.timestamps
    end
  end
end
