class Exercise < ApplicationRecord
    belongs_to :user
    validates :description, presence: true
    validates :duration, presence: true
end
