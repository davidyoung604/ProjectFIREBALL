class SearchesController < ApplicationController
  require 'csv'

  # TODO: consider adding tag, but maybe return files with that tag?
  ALL_SEARCHABLE = [:directory, :user_file].freeze

  def index
    clean_params = search_params
    @results = {}
    # no point continuing if there aren't params or a query
    return if clean_params.empty? || clean_params[:query].empty?

    # split on space but keep "quoted strings" as a single entry
    query_tokens = CSV.parse_line(clean_params[:query], col_sep: ' ')

    ALL_SEARCHABLE.each do |model|
      cls = Module.const_get(model.to_s.camelize)
      @results[model.to_s] = query_records(cls, query_tokens)
    end
  end

  private

  def query_records(cls, query_tokens)
    # id: nil is a hack, but it lets me start the chainable AR magic with
    # a failing condition (id should be guaranteed to not be null)
    target = cls.where(id: nil)
    query_tokens.each do |token|
      token.gsub!('%', '\%') # escape the wildcard
      target = target.or(cls.where('lower(name) LIKE ?', "%#{token.downcase}%"))
    end
    target
  end

  def search_params
    params.permit(:query)
  end
end
