# app/controllers/attendances_controller.rb
class AttendancesController < ApplicationController
  before_action :authenticate_teacher!, only: [:bulk_new, :bulk_create]
  before_action :authenticate_student!, only: [:bulk_show]

  def bulk_show
    @subjects = Subject.where(department_id: current_student.department_id, semester_id: current_student.semester_id)
  end

  def bulk_new
    @departments = Department.all
    @semesters = Semester.all
  end

  def bulk_create
    attendance_params = params.require(:attendance).permit(:subject_id, :semester_id, :attendance_date, students_attributes: [:id, :present])

    # Prepare attendance records for insert_all
    current_time = Time.current
    attendance_records = attendance_params[:students_attributes].values.map do |student|
      {
        subject_id: attendance_params[:subject_id],
        semester_id: attendance_params[:semester_id],
        student_id: student[:id],
        present: student[:present] == '1',
        teacher_id: current_teacher.id,
        attendance_date: attendance_params[:attendance_date],
        created_at: current_time,
        updated_at: current_time
      }
    end

    # Use upsert_all for bulk insertion
    result = Attendance.upsert_all(attendance_records, unique_by: [:subject_id, :semester_id, :student_id, :teacher_id, :attendance_date])

    redirect_to root_path, notice: "#{result.count} attendance records created successfully"
  rescue => e
    redirect_to bulk_new_attendances_path, alert: "Error: #{e.message}"
  end
end
