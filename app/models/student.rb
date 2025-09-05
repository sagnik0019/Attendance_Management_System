class Student < ApplicationRecord

  has_many :attendances
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :department
  belongs_to :semester

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :roll_number, presence: true, length: { maximum: 10 }, uniqueness: true, format: { with: /\A\d{10}\z/ }


  def attendance_percentage(course_id = nil)
    # Get attendances for the specific course if provided
    attendances_scope = course_id ? attendances.where(course_id: course_id) : attendances

    total_classes = attendances_scope.count
    return 0 if total_classes.zero?

    present_count = attendances_scope.where(present: true).count
    ((present_count.to_f / total_classes) * 100).round(2)
  end
end
