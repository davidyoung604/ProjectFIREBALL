module DirectoriesHelper
  def get_dir_name(dir)
    dir.name.split(File::SEPARATOR).last
  end
end
