class Category < ActiveRecord::Base
  has_many :extensions

  validates :name,
            presence: true,
            uniqueness: true

  def csv_extensions
    extensions.map(&:name).join(', ')
  end

  def csv_extensions=(csv_list)
    self.extensions = csv_list.split(/,\s*/).map do |ext|
      Extension.where(name: ext.chomp).first_or_create!
    end
  end
end
