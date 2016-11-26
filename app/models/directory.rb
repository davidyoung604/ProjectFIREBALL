class Directory < ActiveRecord::Base
  has_many :user_files
  belongs_to :parent, class_name: 'Directory'
  has_many :children, class_name: 'Directory', foreign_key: 'parent_id'

  validates :name,
            uniqueness: true,
            presence: true,
            length: { minimum: 1 }

  # ignore_hidden_files is only used for setting up the crawler
  attr_accessor :ignore_hidden_files
  # cascade is only used for editing tags
  attr_accessor :cascade

  def csv_tags
    # grab the tags from the first file to serve as the default
    # this is really just meant as a convenience. dirs don't actually have tags
    return [] if user_files.empty?
    user_files[0].tags.map(&:name).join(', ')
  end

  def csv_tags=(csv_list)
    tags = csv_list.split(/,\s*/).map do |name|
      Tag.where(name: name.chomp).first_or_create!
    end
    set_tags(tags, user_files)
    cascade_tags(tags) if cascade
  end

  def public
    false || (user_files.any? && user_files[0].public)
  end

  def public=(pub)
    user_files.each do |f|
      f.public = pub
      f.save
    end
  end

  private

  def set_tags(tags, files)
    files.each do |file|
      file.tags = tags
      file.touch # update the updated_at field
      file.save
    end
  end

  def cascade_tags(tags)
    # each dir's name is the full path, so child dirs all start the same
    Directory.where('name like ?', "#{name}%").each do |dir|
      set_tags(tags, dir.user_files)
    end
  end
end
