class AddColumnToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :budget, :integer
    add_column :projects, :schedule, :string
  end
end
