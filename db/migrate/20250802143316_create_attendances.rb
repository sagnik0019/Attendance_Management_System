class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :semester, null: false, foreign_key: { on_delete: :cascade }
      t.references :subject, null: false, foreign_key: { on_delete: :cascade }
      t.references :student, null: false, foreign_key: { on_delete: :cascade }
      t.references :teacher, null: false, foreign_key: { on_delete: :cascade }
      t.date :attendance_date, null: false

      t.timestamps
    end

    add_index :attendances, [:semester_id, :subject_id, :student_id, :teacher_id, :attendance_date], unique: true
  end
end
