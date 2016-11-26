class CategoriesController < ApplicationController
  before_action :user_auth
  before_action :admin_auth, only: [:edit, :destroy] # add new and create?

  def index
    @cats = Category.all
  end

  def new
    @cat = Category.new
  end

  def edit
    @cat = Category.find(params[:id])
  end

  def show
    @cat = Category.find(params[:id])

    handle_unsorted

    @exts = @cat.extensions.order(:name)
    @files_by_ext = files_by_ext
    @n_files_in_cat = @files_by_ext.values.map(&:count).reduce(&:+)
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to categories_path
  end

  def create
    @cat = Category.new(category_params)
    if @cat.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def update
    @cat = Category.find(params[:id])
    if @cat.update_attributes(category_params)
      redirect_to @cat
    else
      render 'edit'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :csv_extensions)
  end

  def files_by_ext
    cat_files = {}
    @exts.each { |ext| cat_files[ext.name] = visible_files(ext.user_files) }
    cat_files
  end

  # special case for extensions not yet sorted
  def handle_unsorted
    return if @cat.name != 'Unsorted' # see db/seeds.rb
    @cat.extensions << Extension.where(category_id: nil)
    @cat.save
  end
end
