class Api::BaseController < ApplicationController
  respond_to :json

  private

  def authenticate_teacher!
    return if teacher_signed_in?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def authenticate_student!
    return if student_signed_in?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
