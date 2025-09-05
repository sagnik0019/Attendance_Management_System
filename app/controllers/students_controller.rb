# app/controllers/students_controller.rb
class StudentsController < ApplicationController
  before_action :authenticate_admin!


  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :load_departments_and_semesters, only: [:new, :edit, :create, :update]

  def index
    @students = Student.includes(:department, :semester).all
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student, notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully destroyed.'
  end



  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :email, :password, :password_confirmation,
                                   :roll_number, :department_id, :semester_id)
  end

  def load_departments_and_semesters
    @departments = Department.all
    @semesters = Semester.all
  end
end
