class StatsController < ApplicationController
  before_action :user_auth

  def index
    @total_files = UserFile.count
    @total_data = UserFile.sum(:size)
    @mean_data = UserFile.average(:size)
    middle_record = UserFile.order(:size)[@total_files / 2]
    @median_data = middle_record ? middle_record.size : 0
  end

  def show
    render json: case params[:id]
                 when 'size_by_category'
                   size_by_category
                 when /\d+/
                   suggested_method = params[:id].sub(/(\d+)/, 'n')
                   if respond_to? suggested_method, :include_private
                     send(suggested_method, Regexp.last_match[1])
                   end
                 end
  end

  private

  def size_by_category
    Category.all.map do |cat|
      size = UserFile.where(extension: cat.extensions).sum(:size) || 0
      { Category: cat.name, Size: size }
    end
  end

  def n_largest_files(n)
    UserFile.order(size: :desc).limit(n).map do |file|
      cat = if file.extension.nil? || file.extension.category.nil?
              'Unsorted'
            else
              file.extension.category.name
            end

      { Name: file.name,
        Size: file.size,
        Category: cat }
    end
  end

  def data_usage_n_days(n_days)
    n_days = n_days.to_i
    n_days = 0 if n_days < 0
    # get the usage before the window
    size_at_time = UserFile.where('created_at < ?', n_days.days.ago).sum(:size)
    usage_by_day = data_use_window(n_days)

    usage_by_day.keys.sort.map do |day|
      size_at_time += usage_by_day[day]
      { Date: day, Size: size_at_time }
    end
  end

  # get each day's data total
  def data_use_window(n_days)
    UserFile.where('created_at >= ?', n_days.days.ago)
            .group('date(created_at)')
            .order('date_created_at desc')
            .limit(n_days)
            .sum(:size)
  end

  def top_n_tags(n)
    Tag.joins(:tags_user_files).group(:name)
       .order('count_name desc').limit(n).count(:name).map do |k, v|
      { Name: k, Count: v }
    end
  end
end
