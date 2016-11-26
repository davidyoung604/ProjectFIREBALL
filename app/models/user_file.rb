class UserFile < ActiveRecord::Base
  belongs_to :directory
  belongs_to :extension
  belongs_to :user

  has_and_belongs_to_many :tags

  validates :name,
            presence: true,
            length: { minimum: 1 }
  validates :directory,
            presence: true
  validates :user,
            presence: true

  def csv_tags
    tags.map(&:name).join(', ')
  end

  def csv_tags=(csv_list)
    self.tags = csv_list.split(/,\s*/).map do |name|
      Tag.where(name: name.chomp).first_or_create!
    end
  end
end
