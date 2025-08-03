class Api::AttendancesController < Api::BaseController
  before_action :authenticate_student!, only: :index
  before_action :authenticate_teacher!, only: :existing_attendance

  def index
    @attendance_records = Attendance.where(
      student_id: current_student.id,
      subject_id: params[:subject_id]
    ).order(attendance_date: :desc)

    render json: {
      present_dates: @attendance_records.where(present: true).pluck(:attendance_date),
      absent_dates: @attendance_records.where(present: false).pluck(:attendance_date)
    }
  end

  def existing_attendance
    @attendance_records = Attendance.where(
      teacher_id: current_teacher.id,
      subject_id: params[:subject_id],
      attendance_date: params[:date]
    ).select(:student_id, :present)

    render json: @attendance_records
  end
end
