class AddRoleToTeacher < ActiveRecord::Migration[8.0]
  def change
    add_column :teachers, :role, :smallint, limit: 1, null: false, default: 0
  end
end
