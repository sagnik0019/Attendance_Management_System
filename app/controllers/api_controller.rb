# app/controllers/api_controller.rb
class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_teacher!

  # GET /api/subjects?department_id=X&semester_id=Y
  def subjects
    department_id = params[:department_id]
    semester_id = params[:semester_id]

    if department_id.blank? || semester_id.blank?
      return render json: { error: 'Department ID  Semester ID  are required' }, status: :bad_request
    end

    subjects = Subject.where(department_id: department_id, semester_id: semester_id)
    render json: subjects.as_json(only: [:id, :name, :code])
  end

  # GET /api/students?department_id=X&semester_id=Y
  def students
    department_id = params[:department_id]
    semester_id = params[:semester_id]

    if department_id.blank? || semester_id.blank?
      return render json: { error: 'Department ID and Semester ID are required' }, status: :bad_request
    end

    students = Student.where(department_id: department_id, semester_id: semester_id)
    render json: students.as_json(only: [:id, :name, :roll_number])
  end

  # GET /api/existing_attendance?subject_id=X&date=Y
  def existing_attendance
    subject_id = params[:subject_id]
    date = params[:date]

    if subject_id.blank? || date.blank?
      return render json: { error: 'Subject ID and Date are required' }, status: :bad_request
    end

    attendance_records = Attendance.where(subject_id: subject_id, date: date)
    render json: attendance_records.as_json(only: [:student_id, :present])
  end

  # GET /api/attendance/summary?department_id=X&semester_id=Y&subject_id=Z
  def attendance_summary
    department_id = params[:department_id]
    semester_id = params[:semester_id]
    subject_id = params[:subject_id]

    if department_id.blank? || semester_id.blank? || subject_id.blank?
      return render json: { error: 'Department ID, Semester ID and Subject ID are required' }, status: :bad_request
    end

    # Get all students in the department and semester
    students = Student.where(department_id: department_id, semester_id: semester_id)

    # Calculate attendance for each student
    student_attendance = students.map do |student|
      attendance_records = student.attendances.where(subject_id: subject_id)
      total_classes = attendance_records.count
      present_count = attendance_records.where(present: true).count
      absent_count = total_classes - present_count

      {
        id: student.id,
        roll_number: student.roll_number,
        name: student.name,
        total_classes: total_classes,
        present_count: present_count,
        absent_count: absent_count
      }
    end

    render json: { students: student_attendance }
  end

  # GET /api/attendance/student/:student_id?subject_id=Z
  def student_attendance_details
    student_id = params[:student_id]
    subject_id = params[:subject_id]

    if student_id.blank? || subject_id.blank?
      return render json: { error: 'Student ID and Subject ID are required' }, status: :bad_request
    end

    student = Student.find_by(id: student_id)
    subject = Subject.find_by(id: subject_id)

    if student.nil? || subject.nil?
      return render json: { error: 'Student or Subject not found' }, status: :not_found
    end

    # Get attendance records for the student in this subject
    attendance_records = student.attendances
                                .where(subject_id: subject_id)
                                .order(date: :desc)
                                .as_json(only: [:date, :present])

    # Convert boolean present to status string
    attendance_records.each do |record|
      record['status'] = record['present'] ? 'present' : 'absent'
      record.delete('present')
    end

    render json: {
      student: {
        id: student.id,
        name: student.name
      },
      attendance_records: attendance_records
    }
  end

  private

  def authenticate_teacher!
    # Implement your teacher authentication logic here
    # For Devise: authenticate_teacher! || render json: { error: 'Unauthorized' }, status: :unauthorized

    # Simple implementation (adjust based on your auth system)
    unless current_teacher
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_teacher
    # Implement based on your authentication system
    # For Devise: current_teacher
    # For session-based: Teacher.find(session[:teacher_id]) if session[:teacher_id]

    @current_teacher ||= Teacher.find(session[:teacher_id]) if session[:teacher_id]
  end
end
