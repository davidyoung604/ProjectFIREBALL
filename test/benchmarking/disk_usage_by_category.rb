ActiveRecord::Base.logger.level = 1

# Pre-benchmark fiddling showed original @ 470ms, and updated @ 16ms,
# for an approximate 30x improvement.
puts '--- Disk usage by category ---'

Benchmark.ips do |bm|
  bm.report('original: ') do
    Category.all.map do |cat|
      size = cat.extensions.flat_map(&:user_files).map(&:size).reduce(&:+) || 0
      { Category: cat.name, Size: size }
    end
  end

  bm.report('updated: ') do
    Category.all.map do |cat|
      size = UserFile.where(extension: cat.extensions).sum(:size) || 0
      { Category: cat.name, Size: size }
    end
  end

  bm.compare!
end
