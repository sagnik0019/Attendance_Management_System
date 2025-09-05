class Attendance < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :student
  belongs_to :teacher



  validates :attendance_date, uniqueness: { scope: [:semester_id, :subject_id, :student_id, :teacher_id] }, presence: true
  validates :present, inclusion: { in: [true, false] }
  validates_uniqueness_of :student_id, scope: [:subject_id, :date]

  # Class method to process bulk attendance
  def self.process_bulk_attendance(attendance_params)
    subject_id = attendance_params[:subject_id]
    semester_id = attendance_params[:semester_id]
    date = attendance_params[:attendance_date]
    students_attributes = attendance_params[:students_attributes] || {}

    # Get all students in the semester
    students = Student.where(semester_id: semester_id)

    # Create attendance records
    students_attributes.each do |index, student_attr|
      student_id = student_attr[:id]
      present = student_attr[:present] == '1'

      # Find or initialize attendance record
      attendance = Attendance.find_or_initialize_by(
        student_id: student_id,
        subject_id: subject_id,
        date: date
      )

      attendance.present = present
      attendance.save
    end

    true
  rescue => e
    Rails.logger.error "Error processing bulk attendance: #{e.message}"
    false
  end
end
