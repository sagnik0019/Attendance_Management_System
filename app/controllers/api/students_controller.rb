class Api::StudentsController < Api::BaseController
  before_action :authenticate_teacher!

  def index
    @students = Student.where(department_id: params[:department_id], semester_id: params[:semester_id])
    render json: @students.select(:id, :name, :roll_number)
  end
end
