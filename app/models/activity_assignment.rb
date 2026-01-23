class ActivityAssignment < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validates :position, presence: true
  validates :position, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :activity_id }
end
