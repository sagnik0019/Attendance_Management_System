# app/controllers/subjects_controller.rb
class SubjectsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :render_404_unless_teacher_is_admin

  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_action :load_departments_and_semesters, only: [:new, :edit, :create, :update]

  def index
    @subjects = Subject.includes(:department, :semester).all
  end

  def show
  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end

  def update
    if @subject.update(subject_params)
      redirect_to @subject, notice: 'Subject was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @subject.destroy
    redirect_to subjects_url, notice: 'Subject was successfully destroyed.'
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name, :code, :semester_id, :department_id)
  end

  def load_departments_and_semesters
    @departments = Department.all
    @semesters = Semester.all
  end
end
