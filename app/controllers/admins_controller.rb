class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_student, only: [:show_student, :edit_student, :update_student, :destroy_student]
  before_action :set_teacher, only: [:show_teacher, :edit_teacher, :update_teacher, :destroy_teacher]
  before_action :set_department, only: [:show_department, :edit_department, :update_department, :destroy_department]
  before_action :set_semester, only: [:show_semester, :edit_semester, :update_semester, :destroy_semester]
  before_action :set_subject, only: [:show_subject, :edit_subject, :update_subject, :destroy_subject]


  # Admin Dashboard
  def dashboard
    @students_count = Student.count
    @teachers_count = Teacher.count
    @departments_count = Department.count
    @semesters_count = Semester.count
    @subjects_count = Subject.count
  end

  def current_admin
  @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
end

def admin_signed_in?
  current_admin.present?
end

  # Students Management
  def students
    @students = Student.all
  end

  def new_student
    @student = Student.new
  end

  def create_student
    @student = Student.new(student_params)
    if @student.save
      redirect_to admin_students_path, notice: 'Student was successfully created.'
    else
      render :new_student
    end
  end

  def show_student
  end

  def edit_student
  end

  def update_student
    if @student.update(student_params)
      redirect_to admin_students_path, notice: 'Student was successfully updated.'
    else
      render :edit_student
    end
  end

  def destroy_student
    @student.destroy
    redirect_to admin_students_path, notice: 'Student was successfully deleted.'
  end

  # Teachers Management
  def teachers
    @teachers = Teacher.all
  end

  def new_teacher
    @teacher = Teacher.new
  end

  def create_teacher
    @teacher = Teacher.new(teacher_params)
    if @teacher.save
      redirect_to admin_teachers_path, notice: 'Teacher was successfully created.'
    else
      render :new_teacher
    end
  end

  def show_teacher
  end

  def edit_teacher
  end

  def update_teacher
    if @teacher.update(teacher_params)
      redirect_to admin_teachers_path, notice: 'Teacher was successfully updated.'
    else
      render :edit_teacher
    end
  end

  def destroy_teacher
    @teacher.destroy
    redirect_to admin_teachers_path, notice: 'Teacher was successfully deleted.'
  end

  # Departments Management
  def departments
    @departments = Department.all
  end

  def new_department
    @department = Department.new
  end

  def create_department
    @department = Department.new(department_params)
    if @department.save
      redirect_to admin_departments_path, notice: 'Department was successfully created.'
    else
      render :new_department
    end
  end

  def show_department
  end

  def edit_department
  end

  def update_department
    if @department.update(department_params)
      redirect_to admin_departments_path, notice: 'Department was successfully updated.'
    else
      render :edit_department
    end
  end

  def destroy_department
    @department.destroy
    redirect_to admin_departments_path, notice: 'Department was successfully deleted.'
  end

  # Semesters Management
  def semesters
    @semesters = Semester.all
  end

  def new_semester
    @semester = Semester.new
  end

  def create_semester
    @semester = Semester.new(semester_params)
    if @semester.save
      redirect_to admin_semesters_path, notice: 'Semester was successfully created.'
    else
      render :new_semester
    end
  end

  def show_semester
  end

  def edit_semester
  end

  def update_semester
    if @semester.update(semester_params)
      redirect_to admin_semesters_path, notice: 'Semester was successfully updated.'
    else
      render :edit_semester
    end
  end

  def destroy_semester
    @semester.destroy
    redirect_to admin_semesters_path, notice: 'Semester was successfully deleted.'
  end

  # Subjects Management
  def subjects
    @subjects = Subject.all
  end

  def new_subject
    @subject = Subject.new
  end

  def create_subject
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to admin_subjects_path, notice: 'Subject was successfully created.'
    else
      render :new_subject
    end
  end

  def show_subject
  end

  def edit_subject
  end

  def update_subject
    if @subject.update(subject_params)
      redirect_to admin_subjects_path, notice: 'Subject was successfully updated.'
    else
      render :edit_subject
    end
  end

  def destroy_subject
    @subject.destroy
    redirect_to admin_subjects_path, notice: 'Subject was successfully deleted.'
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def set_department
    @department = Department.find(params[:id])
  end

  def set_semester
    @semester = Semester.find(params[:id])
  end

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :email, :department_id, :semester_id, :roll_number, :date_of_birth)
  end

  def teacher_params
    params.require(:teacher).permit(:name, :email, :department_id, :qualification, :date_of_join)
  end

  def department_params
    params.require(:department).permit(:name, :code, :description)
  end

  def semester_params
    params.require(:semester).permit(:name, :code, :academic_year)
  end

  def subject_params
    params.require(:subject).permit(:name, :code, :department_id, :semester_id, :credits)
  end
end
