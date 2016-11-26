class UserFilesController < ApplicationController
  include UserFilesHelper

  before_action :user_auth

  def index
    results = files_table
    @my_files = results[:my_files]
    @my_public_files = results[:my_public_files]
    @public_files = results[:public_files]
    @remaining_files = current_user.admin ? results[:remaining_files] : []
  end

  def show
    file_and_metadata
  end

  def stream
    @file = UserFile.find(params[:id])
    send_file("#{@file.directory.name}/#{@file.name}",
              filename: @file.name, disposition: :inline,
              stream: true, range: true)
  end

  def edit
    file_and_metadata
  end

  def update
    @file = UserFile.find(params[:id])
    update_and_touch(@file, user_file_params)
  end

  # special case code for listing untagged files
  def untagged
    @files = UserFile.includes(:tags)
                     .where(tags_user_files: { user_file_id: nil })
    @n_files = @files.count
  end

  private

  def user_file_params
    params.require(:user_file).permit(:csv_tags)
  end

  def files_table
    mine = UserFile.where(user: current_user)
    others = UserFile.where.not(user: current_user)
    {
      my_files: mine.where(public: false),
      my_public_files: mine.where(public: true),
      public_files: others.where(public: true),
      remaining_files: others.where(public: false)
    }
  end

  def file_and_metadata
    @file = UserFile.find(params[:id])
    full_path = "#{@file.directory.name}/#{@file.name}"
    @tp = TIFFParser.new(full_path) if run_tiff_parser? @file
  end
end
