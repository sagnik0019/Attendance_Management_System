class Subject < ApplicationRecord
  belongs_to :semester

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 3 }
end
