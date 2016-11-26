# rake db:seed (or created alongside the db with db:setup).

# create default categories for user convenience
{
  'Unsorted' => [],
  'Audio' => %w(flac mp3 ogg wav),
  'Video' => %w(avi flv mkv mov mp4 mpeg mpg wmv),
  'Images' => %w(arw bmp cr2 dng jpeg jpg nef png)
}.each do |cat, exts|
  c = Category.find_or_create_by(name: cat)
  c.extensions = exts.map { |ext| Extension.find_or_create_by(name: ext) }
  c.save
end

# create default Admin user
User.create(
  name: 'Admin', admin: true, password_digest: User.digest('admin')
)
