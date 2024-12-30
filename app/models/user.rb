class User < ApplicationRecord
    has_secure_password
    has_many :images, dependent: :destroy

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
end
