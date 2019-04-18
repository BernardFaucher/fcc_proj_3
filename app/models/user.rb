class User < ApplicationRecord
    has_many :exercises
    validates :username, presence: true
end
