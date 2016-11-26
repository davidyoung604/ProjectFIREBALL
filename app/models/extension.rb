class Extension < ActiveRecord::Base
  belongs_to :category

  has_many :user_files

  validates :name,
            presence: true,
            uniqueness: true
end
