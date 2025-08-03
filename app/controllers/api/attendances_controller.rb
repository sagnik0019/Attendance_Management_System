class Api::AttendancesController < Api::BaseController
  before_action :authenticate_student!

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
end
