class Api::SubjectsController < Api::BaseController
  before_action :authenticate_teacher!

  def index
    @subjects = Subject.where(department_id: params[:department_id], semester_id: params[:semester_id])
    render json: @subjects.select(:id, :name, :code)
  end
end
