class Tag < ActiveRecord::Base
  has_and_belongs_to_many :user_files

  validates :name,
            presence: true,
            uniqueness: true

  # we don't set up tags for directories because we're
  # trying to get away from that particular structure
end
