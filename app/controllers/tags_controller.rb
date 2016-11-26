class TagsController < ApplicationController
  before_action :user_auth
  before_action :admin_auth, only: [:destroy]

  def index
    @tags = Tag.all
    @tag_counts = counts_by_tag
  end

  def show
    @tag = Tag.find(params[:id])
    @tag_files = visible_files(@tag.user_files)
  end

  def destroy
    @tag = Tag.find(params[:id]).destroy
    redirect_to tags_url
  end

  private

  def counts_by_tag
    @tag_counts = {}
    @tags.each do |tag|
      @tag_counts[tag.name] = visible_files(tag.user_files).count
    end
    @tag_counts
  end
end
