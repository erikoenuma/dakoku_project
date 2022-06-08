class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.references :user_project, null: false, foreign_key: true
      t.string :contents

      t.timestamps
    end
  end
end
