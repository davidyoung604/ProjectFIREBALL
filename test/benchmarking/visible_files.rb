ActiveRecord::Base.logger.level = 1

# Pre-benchmark fiddling showed original: 3000ms, updated: 500ms,
# for an approximate 6x improvement.
puts '--- Visible files ---'

u = User.first

Benchmark.ips do |bm|
  bm.report('original: ') do
    list = UserFile.all
    list.select do |f|
      f.public || f.user.id == u.id
    end
  end

  bm.report('updated: ') do
    list = UserFile.all
    list.where(public: true).or(list.where(user: u)).each do |f|
      # accessing these params explicitly to be more fair
      f.id
      f.public
    end
  end

  bm.compare!
end
