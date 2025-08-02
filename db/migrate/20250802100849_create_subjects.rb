class CreateSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :subjects do |t|
      t.string :name, null: false, limit: 255
      t.string :code, null: false, limit: 3
      t.references :semester, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
