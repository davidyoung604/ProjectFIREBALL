# Start indexing each of the provided index requests in the background
class IndexJob < ActiveJob::Base
  require 'disk_crawler'
  include CategoriesHelper
  queue_as :default

  def perform(*args)
    args.each do |index_req|
      log_start(index_req[:base_path], index_req[:user_id])
      begin
        # crawl the specified path
        crawler = ::DiskCrawler.new(index_req)
        crawler.crawl
        log_finish(index_req[:base_path])
        collect_unsorted_extensions
      rescue StandardError => e
        Rails.logger.error e.message
      end
    end
  end

  def log_start(base_path, user_id)
    Rails.logger.info "#{DateTime.now} Starting to crawl " \
                      "#{base_path} as #{user_id}"
  end

  def log_finish(base_path)
    Rails.logger.info "#{DateTime.now} Directory #{base_path} has been crawled."
  end
end
