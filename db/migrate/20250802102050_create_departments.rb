class CreateDepartments < ActiveRecord::Migration[8.0]
  def change
    create_table :departments do |t|
      t.string :name, null: false, limit: 255
      t.string :code, null: false, limit: 2

      t.timestamps
    end
  end
end
