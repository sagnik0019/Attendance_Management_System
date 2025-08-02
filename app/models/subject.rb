class Subject < ApplicationRecord
  belongs_to :semester
  belongs_to :department

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 3 }
end

