ActiveRecord::Base.logger.level = 1

# Pre-benchmark fiddling showed a marginal improvement.
puts '--- Sorting category extensions by name ---'

Benchmark.ips do |bm|
  bm.report('original: ') do
    cat = Category.find(4)
    cat.extensions.sort_by(&:name).each { |e| e }
  end

  bm.report('updated: ') do
    cat = Category.find(4)
    cat.extensions.order(:name).each { |e| e }
  end

  bm.compare!
end
