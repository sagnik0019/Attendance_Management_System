class DepartmentsController < ApplicationController
  before_action :authenticate_admin!


  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, notice: "Department was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])

    if @department.update(department_params)
      redirect_to @department, notice: "Department was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    redirect_to departments_url, notice: "Department was successfully destroyed."
  end

  private

  def department_params
    params.require(:department).permit(:name, :code)
  end
end
