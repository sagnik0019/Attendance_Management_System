class TeachersController < ApplicationController
  before_action :authenticate_admin!  # Only admins can manage teachers
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  def index
    @teachers = Teacher.all
  end

  def show
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)
    if @teacher.save
      redirect_to @teacher, notice: "Teacher was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher, notice: "Teacher was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_url, notice: "Teacher was successfully deleted."
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    # Add any fields you want to manage here
    params.require(:teacher).permit(:email, :name, :department_id, :password, :password_confirmation)
  end
end
