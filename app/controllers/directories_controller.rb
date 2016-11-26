class DirectoriesController < ApplicationController
  before_action :user_auth

  def index
    @dirs = Directory.where(explicitly_indexed: true)
  end

  def show
    @dir = Directory.find(params[:id])
    @dir_files = visible_files(@dir.user_files)
  end

  def edit
    @dir = Directory.find(params[:id])
    @dir_files = visible_files(@dir.user_files)
  end

  def update
    @dir = Directory.find(params[:id])
    update_and_touch(@dir, directory_params)
  end

  def new
    @dir = Directory.new(ignore_hidden_files: true)
  end

  def create
    index_request = {
      base_path: params[:directory][:name],
      ignore_hidden: params[:directory][:ignore_hidden_files],
      user_id: session[:user_id]
    }

    IndexJob.perform_later index_request

    flash[:info] = "Scanning #{index_request[:base_path]} in the background. " \
      'Please allow a few seconds for results to start showing up.'
    redirect_to directories_path
  end

  private

  def directory_params
    params.require(:directory).permit(:cascade, :csv_tags, :public)
  end
end
