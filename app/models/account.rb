class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :tasks, through: :activities
end
