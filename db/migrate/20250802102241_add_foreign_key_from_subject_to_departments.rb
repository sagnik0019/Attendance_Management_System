class AddForeignKeyFromSubjectToDepartments < ActiveRecord::Migration[8.0]
  def change
    add_column :subjects, :department_id, :bigint, null: false
    add_foreign_key :subjects, :departments, on_delete: :cascade
  end
end
