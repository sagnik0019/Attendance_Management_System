class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :department
  belongs_to :semester

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :roll_number, presence: true, length: { maximum: 10 }, uniqueness: true, format: { with: /\A\d{10}\z/ }
end
