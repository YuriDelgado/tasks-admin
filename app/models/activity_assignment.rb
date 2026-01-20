class ActivityAssignment < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validates :position, presence: true, numericality: { only_integer: true }
end
