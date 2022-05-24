class CreateAuthorities < ActiveRecord::Migration[6.0]
  def change
    create_table :authorities do |t|
      t.integer :authority, null: false, default: 0
      t.references :user_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
