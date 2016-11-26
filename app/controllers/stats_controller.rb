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
    case params[:id]
    when 'size_by_category'
      render json: size_by_category
    when /^(\d+)_largest_files$/
      render json: n_largest_files(Regexp.last_match[1])
    when /^top_(\d+)_tags$/
      render json: top_n_tags(Regexp.last_match[1])
    end
  end

  private

  def size_by_category
    Category.all.map do |cat|
      size = cat.extensions.flat_map(&:user_files).map(&:size).reduce(&:+) || 0
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

  def top_n_tags(n)
    Tag.joins(:tags_user_files).group(:name)
       .order('count_name desc').limit(n).count(:name).map do |k, v|
      { Name: k, Count: v }
    end
  end
end
