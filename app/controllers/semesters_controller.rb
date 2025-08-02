class SemestersController < ApplicationController
  before_action :authenticate_teacher!
  before_action :render_404_unless_teacher_is_admin

  def index
    @semesters = Semester.all
  end

  def show
    @semester = Semester.find(params[:id])
  end

  def new
    @semester = Semester.new
  end

  def create
    @semester = Semester.new(semester_params)

    if @semester.save
      redirect_to @semester, notice: "Semester was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @semester = Semester.find(params[:id])
  end

  def update
    @semester = Semester.find(params[:id])

    if @semester.update(semester_params)
      redirect_to @semester, notice: "Semester was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @semester = Semester.find(params[:id])
    @semester.destroy
    redirect_to semesters_url, notice: "Semester was successfully destroyed."
  end

  private

  def semester_params
    params.require(:semester).permit(:name)
  end
end
