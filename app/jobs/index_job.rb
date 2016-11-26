# Start indexing each of the provided index requests in the background
class IndexJob < ActiveJob::Base
  require 'disk_crawler'
  queue_as :default

  def perform(*args)
    args.each do |index_req|
      Rails.logger.info "#{DateTime.now} Starting to crawl " \
                        "#{index_req[:base_path]} as #{index_req[:user_id]}"
      begin
        # crawl the specified path
        crawler = ::DiskCrawler.new(index_req)
        crawler.crawl
        Rails.logger.info "Directory #{index_req[:base_path]} has been crawled."
      rescue StandardError => e
        Rails.logger.error e.message
      end
    end
  end
end
