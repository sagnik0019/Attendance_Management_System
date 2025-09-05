# app/controllers/attendances_controller.rb
class AttendancesController < ApplicationController
  before_action :authenticate_teacher!, only: [:bulk_new, :bulk_create,:bulk_view]
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
        present: student[:present] == '0',
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

  def my_attendance
    @student = current_student # Assuming you have current_student method
    @course = Course.find(params[:course_id]) if params[:course_id]

    # Get filtered attendances
    @attendances = @student.attendances
    @attendances = @attendances.where(course_id: @course.id) if @course

    # Calculate percentage
    @attendance_percentage = @student.attendance_percentage(@course&.id)

    # Order by date descending
    @attendances = @attendances.order(date: :desc)
  end

  # app/controllers/attendances_controller.rb
def bulk_view
  @departments = Department.all
  @semesters = Semester.all

  # Set default date range (current month)
  @start_date = params[:start_date] || Date.today.beginning_of_month
  @end_date = params[:end_date] || Date.today.end_of_month

  # If filters are applied, fetch the data
  if params[:department_id].present? && params[:semester_id].present? && params[:subject_id].present?
    @selected_department = Department.find_by(id: params[:department_id])
    @selected_semester = Semester.find_by(id: params[:semester_id])
    @selected_subject = Subject.find_by(id: params[:subject_id])

    if @selected_department && @selected_semester && @selected_subject
      # Get students for the selected department and semester
      @students = Student.where(
        department_id: @selected_department.id,
        semester_id: @selected_semester.id
      ).order(:roll_number)

      # Calculate attendance data
      @attendance_data = calculate_attendance_data(@students, @selected_subject.id, @start_date, @end_date)

      # Calculate statistics
      @total_classes = calculate_total_classes(@selected_subject.id, @start_date, @end_date)
      @class_stats = calculate_class_statistics(@attendance_data)
    end
  end

  # For the subject dropdown based on selected department and semester
  if params[:department_id].present? && params[:semester_id].present?
    @subjects = Subject.where(
      department_id: params[:department_id],
      semester_id: params[:semester_id]
    )
  else
    @subjects = Subject.all
  end
end

private

def calculate_attendance_data(students, subject_id, start_date, end_date)
  students.map do |student|
    # Get attendance records for this student, subject, and date range
    attendance_records = Attendance.where(
      student_id: student.id,
      subject_id: subject_id,
      date: start_date..end_date
    )

    # Count present and absent days
    present_count = attendance_records.where(present: true).count
    absent_count = attendance_records.where(present: false).count
    total_days = attendance_records.count

    # Calculate percentage
    percentage = total_days > 0 ? (present_count.to_f / total_days * 100).round(2) : 0

    {
      id: student.id,
      roll_number: student.roll_number,
      name: student.name,
      present_count: present_count,
      absent_count: absent_count,
      total_days: total_days,
      percentage: percentage
    }
  end
end

def calculate_total_classes(subject_id, start_date, end_date)
  # Count distinct dates where attendance was recorded for this subject
  Attendance.where(
    subject_id: subject_id,
    date: start_date..end_date
  ).distinct.count(:date)
end

def calculate_class_statistics(attendance_data)
  total_students = attendance_data.size
  return {} if total_students.zero?

  total_percentage = attendance_data.sum { |data| data[:percentage] }
  average_percentage = (total_percentage / total_students).round(2)

  at_risk_count = attendance_data.count { |data| data[:percentage] < 75 && data[:percentage] >= 50 }
  critical_count = attendance_data.count { |data| data[:percentage] < 50 }
  good_count = attendance_data.count { |data| data[:percentage] >= 75 }

  {
    total_students: total_students,
    average_percentage: average_percentage,
    at_risk_count: at_risk_count,
    critical_count: critical_count,
    good_count: good_count
  }
end


end
