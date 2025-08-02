class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def render_404_unless_teacher_is_admin
    return if teacher_signed_in? && current_teacher.admin?

    render file: "#{Rails.root}/public/404.html", status: :unauthorized
  end
end
