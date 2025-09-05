class Api::StudentsController < Api::BaseController
  before_action :authenticate_teacher!

  def index
    @students = Student.where(department_id: params[:department_id], semester_id: params[:semester_id])
    render json: @students.select(:id, :name, :roll_number)
  end

  def with_attendance
    query = <<-SQL
      select students.*, present_count
      from students
      left join lateral (
        select count(attendances.id) as present_count
        from attendances
        where attendances.student_id = students.id
        and attendances.subject_id = #{params[:subject_id]}
        and attendances.present = true
      ) as present_count on true
      where students.department_id = #{params[:department_id]} and students.semester_id = #{params[:semester_id]}
    SQL

    @students = Student.find_by_sql(query).as_json(only: [:id, :name, :roll_number, :present_count])

    total_classes = Attendance.where(subject_id: params[:subject_id], semester_id: params[:semester_id]).distinct.count(:attendance_date)

    @students.each do |student|
      student[:total_classes] = total_classes
      student[:percentage] = ((student["present_count"].to_f / total_classes) * 100).round(2)
    end

    render json: @students
  end
end
