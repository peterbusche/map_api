class Image < ApplicationRecord
    belongs_to :user
    validates :image_path, :latitude, :longitude, presence: true
end
