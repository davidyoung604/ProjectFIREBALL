require 'json'
require 'sqlite3'

# Crawls the specified path and creates DB records for each directory and file.
class DiskCrawler
  def initialize(args = {})
    base_path = args[:base_path] || '/'
    @base_dir = Directory.find_or_create_by!(name: base_path)
    @base_dir.explicitly_indexed = true
    @base_dir.save # force it to show up BEFORE indexing is done
    @base_dir.touch # force-update the updated_at field
    @ignore_hidden = args[:ignore_hidden] || false
    @user_id = args[:user_id]
  end

  def crawl(cur_dir = @base_dir)
    Rails.logger.info "Entering #{cur_dir.name}"
    Dir.entries(cur_dir.name).each do |entry|
      next if ignore_file? entry
      path = cur_dir.name + File::SEPARATOR + entry
      next unless File.exist? path

      file_or_dir(path, cur_dir)
    end
    cur_dir.save
  end

  private

  def file_or_dir(path, cur_dir)
    if File.directory? path
      handle_dir(path, cur_dir)
    else
      # TODO: what happens if a file is a symlink?
      cur_dir.user_files << new_user_file(cur_dir, path)
    end
  end

  def handle_dir(path, parent_dir)
    if File.symlink? path
      Rails.logger.warn path, 'Symlink. ' \
        'Avoiding potential infinite loops by not following.'
    elsif File.readable? path
      new_dir = Directory.find_or_create_by!(name: path)
      new_dir.parent = parent_dir
      new_dir.save
      crawl(new_dir)
    else
      Rails.logger.warn path, 'Can\'t access directory.'
    end
  end

  def new_user_file(dir, path)
    Rails.logger.info 'Creating entry for ' + path

    # in case the file doesn't have an extension
    ext_name = File.extname(path)[1..-1] || ''

    ext = Extension.find_or_create_by(
      name: ext_name.downcase # .mp4 -> mp4
    )

    UserFile.find_or_initialize_by(
      name: File.basename(path),
      size: File.size(path),
      directory_id: dir.id,
      extension_id: ext.id,
      user_id: @user_id
    )
  end

  def ignore_file?(file)
    return true if ['.', '..'].include? file # infinite loops are bad
    return true if @ignore_hidden && file =~ /^\./
  end
end
