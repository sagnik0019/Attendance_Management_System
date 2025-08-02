class Attendance < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :student
  belongs_to :teacher

  validates :attendance_date, uniqueness: { scope: [:semester_id, :subject_id, :student_id, :teacher_id] }, presence: true
end
